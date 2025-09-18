#!/usr/bin/env python3
"""
RStudio Version Updater
Checks for the latest stable RStudio version and updates the Ansible playbook if needed.
"""

import re
import sys
import os
import subprocess

# Try to import requests, install if missing
try:
    import requests
except ImportError:
    print("📦 Installing required Python package: requests")
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "requests"])
        import requests
        print("✅ Successfully installed requests")
    except Exception as e:
        print(f"❌ Failed to install requests: {e}")
        print("Please install it manually: python3 -m pip install requests")
        sys.exit(1)

def get_latest_stable_version():
    """Fetch the latest stable RStudio version from the official download page."""
    try:
        response = requests.get('https://posit.co/download/rstudio-desktop/', timeout=10)
        response.raise_for_status()
        content = response.text
        
        # Pattern for Ubuntu DEB files: rstudio-VERSION-amd64.deb
        deb_pattern = r'rstudio-([0-9]+\.[0-9]+\.[0-9]+-[0-9]+)-amd64\.deb'
        matches = re.findall(deb_pattern, content)
        
        if matches:
            # Get unique versions and return the latest
            versions = list(set(matches))
            latest_version = sorted(versions, reverse=True)[0]
            return latest_version
        else:
            print("⚠ No version patterns found on the download page")
            return None
            
    except Exception as e:
        print(f"❌ Error fetching latest version: {e}")
        return None

def get_current_version_from_playbook(playbook_path):
    """Extract the current RStudio version from the Ansible playbook."""
    try:
        with open(playbook_path, 'r') as f:
            content = f.read()
            
        # Look for rstudio_version: VERSION pattern
        version_pattern = r'rstudio_version:\s*([0-9]+\.[0-9]+\.[0-9]+-[0-9]+)'
        match = re.search(version_pattern, content)
        
        if match:
            return match.group(1)
        else:
            print("⚠ Could not find rstudio_version in playbook")
            return None
            
    except Exception as e:
        print(f"❌ Error reading playbook: {e}")
        return None

def update_playbook_version(playbook_path, old_version, new_version):
    """Update the RStudio version in the Ansible playbook."""
    try:
        with open(playbook_path, 'r') as f:
            content = f.read()
            
        # Replace the version
        old_line = f"rstudio_version: {old_version}"
        new_line = f"rstudio_version: {new_version}"
        updated_content = content.replace(old_line, new_line)
        
        if updated_content != content:
            # Create backup
            backup_path = f"{playbook_path}.backup"
            with open(backup_path, 'w') as f:
                f.write(content)
            print(f"📁 Created backup: {backup_path}")
            
            # Write updated version
            with open(playbook_path, 'w') as f:
                f.write(updated_content)
            print(f"✅ Updated {playbook_path}")
            return True
        else:
            print("⚠ No changes made to playbook")
            return False
            
    except Exception as e:
        print(f"❌ Error updating playbook: {e}")
        return False

def verify_version_accessibility(version):
    """Verify that the new version is accessible via download URL."""
    test_url = f"https://download1.rstudio.org/electron/jammy/amd64/rstudio-{version}-amd64.deb"
    
    try:
        response = requests.head(test_url, timeout=10)
        if response.status_code == 200:
            size = response.headers.get('content-length', 'Unknown')
            if size != 'Unknown':
                size_mb = round(int(size) / (1024*1024), 1)
                print(f"✅ Version {version} verified: {size_mb} MB")
            else:
                print(f"✅ Version {version} verified")
            return True
        else:
            print(f"❌ Version {version} not accessible: HTTP {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Error verifying version {version}: {e}")
        return False

def main():
    # Look for playbook in parent directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    playbook_path = os.path.join(os.path.dirname(script_dir), "geoscripting-gui.yml")
    
    if not os.path.exists(playbook_path):
        print(f"❌ Playbook not found: {playbook_path}")
        print("Please ensure geoscripting-gui.yml exists in the parent directory.")
        sys.exit(1)
    
    print("RStudio Version Checker")
    print("=" * 30)
    
    # Get current version from playbook
    current_version = get_current_version_from_playbook(playbook_path)
    if not current_version:
        sys.exit(1)
    
    print(f"Current version in playbook: {current_version}")
    
    # Get latest stable version
    latest_version = get_latest_stable_version()
    if not latest_version:
        sys.exit(1)
    
    print(f"Latest stable version: {latest_version}")
    
    # Compare versions
    if current_version == latest_version:
        print("✅ Playbook is up to date!")
        sys.exit(0)
    
    print(f"🔄 Update available: {current_version} → {latest_version}")
    
    # Verify new version is accessible
    if not verify_version_accessibility(latest_version):
        print("❌ Cannot update to inaccessible version")
        sys.exit(1)
    
    # Ask for confirmation
    response = input(f"Update playbook to version {latest_version}? [y/N]: ").strip().lower()
    
    if response in ['y', 'yes']:
        if update_playbook_version(playbook_path, current_version, latest_version):
            print("🎉 Update completed successfully!")
            print(f"Updated from {current_version} to {latest_version}")
        else:
            print("❌ Update failed")
            sys.exit(1)
    else:
        print("Update cancelled")

if __name__ == "__main__":
    main()

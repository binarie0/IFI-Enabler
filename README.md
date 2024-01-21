# IFI Enabler
 This program turns on Instant File Initialization with a nice little UI (made to use in conjunction with diskspd-auto so the program can run at full efficiency)

## How it works
 This program edits a key in the registry titled *SeManageVolumePrivilege*. This allows diskspd.exe to instantaneously allocate memory in a volume for testing.

 Without this turned on, diskspd.exe takes around 2-3x longer as it needs to take more time to allocate memory.

### Credits
 Original code snippet from https://github.com/fashionproof/EnableAllTokenPrivs -> edited to just be SeManageVolumePrivilege    
 binarie0 -> UI Implementation, Graphics, and Functionality    
 EarthToFatt -> Graphics    

### Credits for SE Volume Benchmark [better name pending] (not on Github yet as of 20 Jan 2024)    
 binarie0 -> UI Implementation, Graphics, and Functionality   
 EarthToFatt -> Code Restructuring, Graphics, Output to Word   
 
#### Changelog
    20 Jan 2024 - Initial Commit to Github (applying licenses and attaching actual code)

# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms

## code snippet from https://github.com/fashionproof/EnableAllTokenPrivs -> edited to just be managevolumepriveleges (for obvious reasons)
## ^ All Credit goes to Lee Holmes (@Lee_Holmes on twitter).  I found the code here https://www.leeholmes.com/blog/2010/09/24/adjusting-token-privileges-in-powershell/
$tokenPriv                              = @'
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.InteropServices;

namespace Set_TokenPermission
{
    public class SetTokenPriv
    {
        [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
        internal static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall,
        ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr relen);
        [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
        internal static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);
        [DllImport("advapi32.dll", SetLastError = true)]
        internal static extern bool LookupPrivilegeValue(string host, string name, ref long pluid);
        [StructLayout(LayoutKind.Sequential, Pack = 1)]
        internal struct TokPriv1Luid
        {
            public int Count;
            public long Luid;
            public int Attr;
        }
        internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
        internal const int SE_PRIVILEGE_DISABLED = 0x00000000;
        internal const int TOKEN_QUERY = 0x00000008;
        internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;
        public static void EnablePrivilege()
        {
            bool retVal;
            TokPriv1Luid tp;
            IntPtr hproc = new IntPtr();
            hproc = Process.GetCurrentProcess().Handle;
            IntPtr htok = IntPtr.Zero;
            
            //privelege that needs to be enabled for fast read
            string priv = "SeManageVolumePrivilege";
            


            

            retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
            tp.Count = 1;
            tp.Luid = 0;
            tp.Attr = SE_PRIVILEGE_ENABLED;

            
            
            retVal = LookupPrivilegeValue(null, priv, ref tp.Luid);
            retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);                              
        }
        public static void DisablePrivilege()
        {
            bool retVal;
            TokPriv1Luid tp;
            IntPtr hproc = new IntPtr();
            hproc = Process.GetCurrentProcess().Handle;
            IntPtr htok = IntPtr.Zero;

            //privelege that needs to be enabled for fast read
            string priv = "SeManageVolumePrivilege";
            


            

            retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
            tp.Count = 1;
            tp.Luid = 0;
            tp.Attr = SE_PRIVILEGE_DISABLED;

            
            
            retVal = LookupPrivilegeValue(null, priv, ref tp.Luid);
            retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
        }
    }  
}
'@
#initialized tokenPrivelege functions first for simplicity
$privelegeHandler                       = Add-Type $tokenPriv -PassThru 


# Create a new form
[System.Windows.Forms.Application]::EnableVisualStyles()  

$DisplayWindow                          = New-Object System.Windows.Forms.Form
$bgImage                                = [System.Drawing.Image]::FromFile($PSScriptRoot + "\bg.jpg")
# Define the size, title and background color
$DisplayWindow.ClientSize               = '1000,600'
$DisplayWindow.text                     = "Fast-Load --> Diskspd.exe"
$DisplayWindow.BackColor                = "#ffffff"
$DisplayWindow.MaximumSize              = '1000,600'
$DisplayWindow.MinimumSize              = '1000,600'
$DisplayWindow.BackgroundImage          = $bgImage
$DisplayWindow.BackgroundImageLayout    = "None"




#Initialize Title Label
$Title                                  = New-Object System.Windows.Forms.Label

#Title characteristics
$Title.Text                             = "Welcome to the fast loader for Diskspd.exe"
$Title.Width                            = 1000
$Title.Height                           = 125
$Title.location                         = New-Object System.Drawing.Point(0, 75)
$Title.Font                             = 'Tahoma, 40'
$Title.TextAlign                        = [System.Drawing.ContentAlignment]::BottomCenter
$Title.BackColor                        = [System.Drawing.Color]::Transparent;
$Title.ForeColor                        = [System.Drawing.Color]::White;

#Add title to form
$DisplayWindow.Controls.Add($Title)
#Initialize Description Label
$Description                            = New-Object System.Windows.Forms.Label

#Title characteristics
$Description.Text                       = "In order for Diskspd.exe to function at full capacity, Instant File Initialization (IFI) must be enabled. This leaves the computer vulnerable to attackers looking to gain access to the C: drive. To protect the computer, please turn off all internet connection prior to enabling. Internet can be turned on at your own discetion. Please restart your computer for the changes to take effect."
$Description.Width                      = 800
$Description.Height                     = 350
$Description.location                   = New-Object System.Drawing.Point(100, 125)       
$Description.Font                       = 'Segoe UI Semibold, 20'
$Description.TextAlign                  = [System.Drawing.ContentAlignment]::BottomCenter
$Description.BackColor                  = [System.Drawing.Color]::Transparent;
$Description.ForeColor                  = [System.Drawing.Color]::White;


#Add description to form
$DisplayWindow.Controls.Add($Description)




<#
.SYNOPSIS
#Enables Instant File Initialization

.DESCRIPTION
Enables Instant File Initialization through looking up the value in the registry and replacing the value present with the enabled value.

.EXAMPLE
$EnableButton.Add_Click($enable_priveleges)
#>
function enable_priveleges() {
    #Enable SE_MANAGE_VOLUME
    $privelegeHandler[0]::EnablePrivilege()         2>&1
    Write-Host "User enabled priveleges"
}
<#
.SYNOPSIS
#Disables Instant File Initialization

.DESCRIPTION
Disables Instant File Initialization through looking up the value in the registry and replacing the value present with the disabled value.

.EXAMPLE
$DisableButton.Add_Click($disable_priveleges)
#>
function disable_priveleges() {
    #Disable SE_MANAGE_VOLUME
    $privelegeHandler[0]::DisablePrivilege()        2>&1
    Write-Host "User disabled priveleges"
}


$EnableButton                           = New-Object System.Windows.Forms.Button
$DisableButton                           = New-Object System.Windows.Forms.Button


$EnableButton.Text                      = "Enable"
$EnableButton.Width                     = 100
$EnableButton.Height                    = 50
$EnableButton.Location                  = New-Object System.Drawing.Point(200, 500)
$EnableButton.Font                      = 'Segoe UI Semibold, 15'
#Set up on click for the enable button
$EnableButton.Add_Click($function:enable_priveleges)

#Add enable button to form
$DisplayWindow.Controls.Add($EnableButton)

$DisableButton.Text                      = "Disable"
$DisableButton.Width                     = 100
$DisableButton.Height                    = 50
$DisableButton.Location                  = New-Object System.Drawing.Point(700, 500)
$DisableButton.Font                      = 'Segoe UI Semibold, 15'
#Set up on click for the disable button
$DisableButton.Add_Click($function:disable_priveleges)

#Add disable button to form
$DisplayWindow.Controls.Add($DisableButton)






#Show Form
$DisplayWindow.ShowDialog()


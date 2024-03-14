###############################################################
## Add Users to WVD2 Groups
## Author - Neil Robson
## 16/02/2024
## V 1.1
###############################################################

Add-Type -AssemblyName System.Windows.Forms

# Create a form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Add User to WVD2 Groups"
$form.Size = New-Object System.Drawing.Size(400, 450)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false

# Create a label for username
$usernameLabel = New-Object System.Windows.Forms.Label
$usernameLabel.Location = New-Object System.Drawing.Point(10, 20)
$usernameLabel.Size = New-Object System.Drawing.Size(320, 20)
$usernameLabel.Text = "Enter the username:"
$form.Controls.Add($usernameLabel)

# Create a textbox for username input
$usernameTextBox = New-Object System.Windows.Forms.TextBox
$usernameTextBox.Location = New-Object System.Drawing.Point(10, 40)
$usernameTextBox.Size = New-Object System.Drawing.Size(320, 20)
$form.Controls.Add($usernameTextBox)

# Create a group box for checkboxes
$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = New-Object System.Drawing.Point(10, 75)
$groupBox.Size = New-Object System.Drawing.Size(360, 265)
$groupBox.Text = "Select groups to add the user to:"
$form.Controls.Add($groupBox)

# Specify the Active Directory groups to add the user to
$groups = @(
    "Azure_WVD2_UK_General",
    "Azure_WVD2_UK_BIM",
    "Azure_WVD2_UK_RDP",
    "Azure_WVD2_UK_ESRI_NonGPU",
    "Azure_WVD2_UK_ESRI_GPU",
    "Azure_WVD2_EUR_General",
    "Azure_WVD2_EUR_BIM",
    "Azure_WVD2_EUR_RDP",
    "Azure_WVD2_EUR_ESRI_NonGPU",
    "Azure_WVD2_EUR_ESRI_GPU",
    "ADS_BI"
)

# Calculate Y-coordinate for each checkbox
$y = 20
foreach ($group in $groups) {
    $checkbox = New-Object System.Windows.Forms.CheckBox
    $checkbox.Location = New-Object System.Drawing.Point(10, $y)
    $checkbox.Size = New-Object System.Drawing.Size(280, 20)
    $checkbox.Text = $group
    $groupBox.Controls.Add($checkbox)
    $y += 25  # Increment Y-coordinate to space out checkboxes
}

# Create a button to execute the action
$button = New-Object System.Windows.Forms.Button
$button.Size = New-Object System.Drawing.Size(100, 30)
$button.Text = "Add to Groups"
$button.Dock = "Bottom"  # Dock the button to the bottom of the form
$button.Add_Click({
    $username = $usernameTextBox.Text
    foreach ($checkbox in $groupBox.Controls) {
        if ($checkbox.Checked) {
            $group = $checkbox.Text
            try {
                Add-ADGroupMember -Identity $group -Members $username -ErrorAction Stop
                [System.Windows.Forms.MessageBox]::Show("User '$username' added to group '$group' successfully","Success",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)
            } catch {
                [System.Windows.Forms.MessageBox]::Show("Failed to add user '$username' to group '$group': $_","Error",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
            }
        }
    }
})
$form.Controls.Add($button)

# Create a label for author information
#$authorLabel = New-Object System.Windows.Forms.Label
#$authorLabel.Size = New-Object System.Drawing.Size(320, 20)
#$authorLabel.Text = "Author: Neil Robson 2024"
#$authorLabel.Font = New-Object System.Drawing.Font("Arial", 8)  # Adjust font size
# Calculate Y-coordinate for the label at the bottom
#$authorLabel.Location = New-Object System.Drawing.Point(($form.ClientSize.Width - $authorLabel.Width) / 2, $form.ClientSize.Height - $authorLabel.Height - 10)
#$form.Controls.Add($authorLabel)

# Show the form
$form.ShowDialog() | Out-Null

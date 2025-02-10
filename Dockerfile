# Use the latest Windows Server Core image
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set environment variables
ENV NGROK_ZIP_URL=https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip^
    NGROK_ZIP_PATH=C:\ngrok.zip^
    NGROK_INSTALL_PATH=C:\ngrok^
    NGROK_AUTH_TOKEN=2sqJ73Y2399qMylF1QD83UwANZZ_2ayshDPtaVWnKaCZ8KBJE^
    RDP_USER=vikram^
    RDP_PASSWORD=Vikram@123

# Download ngrok
RUN powershell -Command `
    Invoke-WebRequest -Uri $env:NGROK_ZIP_URL -OutFile $env:NGROK_ZIP_PATH; `
    Expand-Archive -Path $env:NGROK_ZIP_PATH -DestinationPath $env:NGROK_INSTALL_PATH; `
    Remove-Item -Path $env:NGROK_ZIP_PATH

# Authenticate ngrok
RUN powershell -Command `
    & $env:NGROK_INSTALL_PATH\ngrok.exe authtoken $env:NGROK_AUTH_TOKEN

# Enable Remote Desktop and set user credentials
RUN powershell -Command `
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0; `
    Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'; `
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'UserAuthentication' -Value 1; `
    net user $env:RDP_USER $env:RDP_PASSWORD /add; `
    net localgroup administrators $env:RDP_USER /add

# Expose RDP port
EXPOSE 3389

# Start ngrok tunnel
CMD $env:NGROK_INSTALL_PATH\ngrok.exe tcp 3389

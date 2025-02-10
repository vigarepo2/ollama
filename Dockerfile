# Use the latest Windows Server Core image
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set environment variables
ENV NGROK_ZIP_URL=https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip `
    NGROK_ZIP_PATH=C:\ngrok.zip `
    NGROK_INSTALL_PATH=C:\ngrok `
    NGROK_AUTH_TOKEN=2sqJ73Y2399qMylF1QD83UwANZZ_2ayshDPtaVWnKaCZ8KBJE `
    RDP_USER=vikram `
    RDP_PASSWORD=Vikram@123

# Download ngrok
RUN powershell -Command `
    Invoke-WebRequest -Uri %NGROK_ZIP_URL% -OutFile %NGROK_ZIP_PATH%; `
    Expand-Archive -Path %NGROK_ZIP_PATH% -DestinationPath %NGROK_INSTALL_PATH%; `
    Remove-Item -Path %NGROK_ZIP_PATH%

# Authenticate ngrok
RUN powershell -Command `
    & %NGROK_INSTALL_PATH%\ngrok.exe authtoken %NGROK_AUTH_TOKEN%

# Enable Remote Desktop and set user credentials
RUN powershell -Command `
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0; `
    Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'; `
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'UserAuthentication' -Value 1; `
    net user %RDP_USER% %RDP_PASSWORD% /add; `
    net localgroup administrators %RDP_USER% /add

# Expose RDP port
EXPOSE 3389

# Start ngrok tunnel
CMD %NGROK_INSTALL_PATH%\ngrok.exe tcp 3389

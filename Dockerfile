# Use the official CapRover image as the base
FROM caprover/caprover:latest

# Expose the ports CapRover uses for HTTP and HTTPS
EXPOSE 80
EXPOSE 443

# Start CapRover when the container launches
CMD ["caprover", "start"]

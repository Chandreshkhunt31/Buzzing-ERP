FROM frappe/erpnext:v15.65.4

# Set environment variables
ENV ERPNEXT_VERSION=v15.65.4

# Copy configuration script
COPY setup.sh /setup.sh

# Expose port
EXPOSE 8000

# Start the backend service using bash to execute the script
CMD ["bash", "/setup.sh"] 
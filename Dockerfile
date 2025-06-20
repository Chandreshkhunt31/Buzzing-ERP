FROM frappe/erpnext:v15.65.4

# Set environment variables
ENV ERPNEXT_VERSION=v15.65.4

# Copy configuration script
COPY setup.sh /setup.sh
RUN chmod +x /setup.sh

# Expose port
EXPOSE 8000

# Start the backend service
CMD ["/setup.sh"] 
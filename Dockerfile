FROM frappe/erpnext:v15.65.4

# Set environment variables
ENV ERPNEXT_VERSION=v15.65.4

# Copy configuration script to a writable location
COPY setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh && mv /tmp/setup.sh /setup.sh

# Expose port
EXPOSE 8000

# Start the backend service
CMD ["/setup.sh"] 
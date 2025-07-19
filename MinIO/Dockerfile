# Use a fixed MinIO release (adjust if you prefer another)
FROM quay.io/minio/minio:RELEASE.2024-01-05T22-17-24Z

# Define legacy credential environment variables (NOT recommended for real secrets)
ENV MINIO_ACCESS_KEY=MyAccessKey \
    MINIO_SECRET_KEY=MySuperSecretKey123

# Expose S3 API and Web Console ports
EXPOSE 9000 9001

# Start MinIO server (API :9000, Console UI :9001)
ENTRYPOINT ["minio"]
CMD ["server", "/data", "--address", ":9000", "--console-address", ":9001"]

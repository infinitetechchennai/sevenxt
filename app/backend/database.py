import psycopg2 # Use the PostgreSQL adapter
from psycopg2 import Error
import os
from dotenv import load_dotenv

# Load your existing environment variables
load_dotenv()

def get_db_connection():
    """
    Establishes a connection to the PostgreSQL database.
    Prioritizes DATABASE_URL if available (for Render/Cloud), 
    otherwise falls back to local explicitly.
    """
    try:
        db_url = os.getenv("DATABASE_URL")
        
        if db_url:
            connection = psycopg2.connect(db_url, connect_timeout=10)
        else:
            connection = psycopg2.connect(
                # REPLACE with your System A (Office) IP address from ipconfig
                host=os.getenv("DB_HOST", "192.168.1.6"), 
                
                # Your PostgreSQL credentials
                user=os.getenv("DB_USER", "postgres"),
                password=os.getenv("DB_PASSWORD", "12345"),
                database=os.getenv("DB_NAME", "sevenext"),
                port=int(os.getenv("DB_PORT", "5432")),
                
                # Optional: Prevents the app from hanging if the network is down
                connect_timeout=10 
            )
        
        # Test if the connection is successful
        if connection:
            return connection
            
    except Error as e:
        print(f"Database connection error: {e}")
        print("Tip: Ensure System A Firewall allows Port 5432 and pg_hba.conf is updated, or DATABASE_URL is correct.")
        raise Exception("Failed to connect to the database")

# Test the connection when running this file directly
if __name__ == "__main__":
    conn = get_db_connection()
    if conn:
        print("Successfully connected to the database!")
        conn.close()

import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

def add_razorpay_order_id_column():
    print("Initiating database migration for 'orders' table...")
    try:
        # Connect to DB using the same logic as the main app
        db_url = os.getenv("DATABASE_URL")
        if db_url:
            print("Connecting using DATABASE_URL...")
            conn = psycopg2.connect(db_url, connect_timeout=10)
        else:
            print("Connecting using local credentials...")
            conn = psycopg2.connect(
                host=os.getenv("DB_HOST", "192.168.1.6"),
                user=os.getenv("DB_USER", "postgres"),
                password=os.getenv("DB_PASSWORD", "12345"),
                database=os.getenv("DB_NAME", "sevenext"),
                port=int(os.getenv("DB_PORT", "5432")),
                connect_timeout=10
            )
        
        conn.autocommit = True
        cursor = conn.cursor()
        
        # Add the missing column
        alter_query = """
        ALTER TABLE orders 
        ADD COLUMN IF NOT EXISTS razorpay_order_id VARCHAR(100);
        """
        cursor.execute(alter_query)
        print("✅ Successfully added 'razorpay_order_id' column to the 'orders' table.")
        
        cursor.close()
        conn.close()
        
    except psycopg2.Error as e:
        print(f"❌ Database error: {e}")
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    add_razorpay_order_id_column()

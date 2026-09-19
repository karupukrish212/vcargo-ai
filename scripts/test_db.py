from app.core.database import check_database_connection


def main() -> None:
    print("Checking MySQL connection...")

    is_connected = check_database_connection()

    if is_connected:
        print("MySQL connection successful.")
    else:
        print("MySQL connection failed.")


if __name__ == "__main__":
    main()
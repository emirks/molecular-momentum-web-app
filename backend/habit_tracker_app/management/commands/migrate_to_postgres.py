from django.core.management.base import BaseCommand
from django.core.management import call_command
from django.db import connections
from django.conf import settings
import os
import json
import sqlite3
import psycopg2
import traceback

class Command(BaseCommand):
    help = 'Migrate data from SQLite to PostgreSQL'

    def handle(self, *args, **options):
        # Ensure we're using PostgreSQL
        if 'postgresql' not in settings.DATABASES['default']['ENGINE']:
            self.stdout.write(self.style.ERROR('This command is intended for PostgreSQL only.'))
            return

        # Dump data from SQLite
        self.stdout.write(self.style.SUCCESS('Dumping data from SQLite...'))
        try:
            self.manual_dump()
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'Error during manual dump: {str(e)}'))
            self.stdout.write(self.style.ERROR(traceback.format_exc()))
            return

        # Test PostgreSQL connection
        self.stdout.write(self.style.SUCCESS('Testing PostgreSQL connection...'))
        try:
            self.test_postgres_connection()
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'Error connecting to PostgreSQL: {str(e)}'))
            self.stdout.write(self.style.ERROR(traceback.format_exc()))
            return

        # Apply migrations to PostgreSQL
        self.stdout.write(self.style.SUCCESS('Applying migrations to PostgreSQL...'))
        try:
            call_command('migrate')
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'Error during migration: {str(e)}'))
            self.stdout.write(self.style.ERROR(traceback.format_exc()))
            return

        # Load data into PostgreSQL
        self.stdout.write(self.style.SUCCESS('Loading data into PostgreSQL...'))
        try:
            call_command('loaddata', 'data_dump.json')
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'Error loading data: {str(e)}'))
            self.stdout.write(self.style.ERROR(traceback.format_exc()))
            return

        self.stdout.write(self.style.SUCCESS('Migration completed successfully!'))

    def manual_dump(self):
        from django.apps import apps
        all_data = []
        sqlite_db_path = 'db.sqlite3'  # Update this path if your SQLite database is located elsewhere

        with sqlite3.connect(sqlite_db_path) as conn:
            conn.text_factory = lambda b: b.decode(errors='ignore')
            cursor = conn.cursor()

            for model in apps.get_models():
                if model._meta.app_label not in ['auth', 'contenttypes']:
                    table_name = model._meta.db_table
                    self.stdout.write(f'Dumping {model._meta.app_label}.{model._meta.model_name}')
                    try:
                        cursor.execute(f"SELECT * FROM {table_name}")
                        columns = [column[0] for column in cursor.description]
                        for row in cursor.fetchall():
                            item = dict(zip(columns, row))
                            item['model'] = f"{model._meta.app_label}.{model._meta.model_name}"
                            all_data.append(item)
                    except Exception as e:
                        self.stdout.write(self.style.WARNING(f'Error dumping {model._meta.app_label}.{model._meta.model_name}: {str(e)}'))

        with open('data_dump.json', 'w', encoding='utf-8') as f:
            json.dump(all_data, f, ensure_ascii=False, indent=2, default=str)

    def test_postgres_connection(self):
        db_settings = settings.DATABASES['default']
        conn = psycopg2.connect(
            dbname=db_settings['NAME'],
            user=db_settings['USER'],
            password=db_settings['PASSWORD'],
            host=db_settings['HOST'],
            port=db_settings['PORT']
        )
        conn.close()
        self.stdout.write(self.style.SUCCESS('Successfully connected to PostgreSQL'))

# Generated by Django 5.1.2 on 2024-10-10 17:52

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("habit_tracker_app", "0001_initial"),
    ]

    operations = [
        migrations.RemoveIndex(
            model_name="habitcompletion",
            name="habit_compl_habit_i_a1731b_idx",
        ),
        migrations.AlterField(
            model_name="habitcompletion",
            name="completed_at",
            field=models.DateTimeField(auto_now_add=True),
        ),
    ]

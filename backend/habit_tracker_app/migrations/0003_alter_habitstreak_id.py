from django.db import migrations, models

def transfer_uuid_to_bigint(apps, schema_editor):
    HabitStreak = apps.get_model('habit_tracker_app', 'HabitStreak')
    db_alias = schema_editor.connection.alias
    for streak in HabitStreak.objects.using(db_alias).all():
        streak.new_id = int(streak.id.hex, 16) % (2**63)
        streak.save()

class Migration(migrations.Migration):

    dependencies = [
        ('habit_tracker_app', '0002_remove_habitcompletion_habit_compl_habit_i_a1731b_idx_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='habitstreak',
            name='new_id',
            field=models.BigIntegerField(null=True),
        ),
        migrations.RunPython(transfer_uuid_to_bigint),
        migrations.RemoveField(
            model_name='habitstreak',
            name='id',
        ),
        migrations.RenameField(
            model_name='habitstreak',
            old_name='new_id',
            new_name='id',
        ),
        migrations.AlterField(
            model_name='habitstreak',
            name='id',
            field=models.BigAutoField(primary_key=True, serialize=False, auto_created=True),
        ),
    ]


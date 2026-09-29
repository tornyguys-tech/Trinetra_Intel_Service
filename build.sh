#!/usr/bin/env bash
# build.sh - Render build script for TornSpy / ThreatLens SOC Simulation
# Runs automatically during every Render deploy.
set -o errexit

pip install -r requirements.txt
python manage.py collectstatic --noinput
python manage.py migrate

# Ensure superuser rana and SpyUser rana are configured on deploy
python manage.py shell -c "from django.contrib.auth.models import User; from tracker.models import SpyUser; u, _ = User.objects.get_or_create(username='rana'); u.set_password('rana'); u.is_superuser = True; u.is_staff = True; u.save(); su, _ = SpyUser.objects.get_or_create(player_name='rana', defaults={'player_id': 777777, 'api_key': 'rana', 'is_admin': True}); su.is_admin = True; su.api_key = 'rana'; su.save()"

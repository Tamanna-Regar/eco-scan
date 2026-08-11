from django.contrib import admin
from .models import UserProfile, ScanHistory

# Register your models here.
admin.site.register(UserProfile)
admin.site.register(ScanHistory)
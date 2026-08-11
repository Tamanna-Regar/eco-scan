from django.db import models

# Create your models here.

from django.db import models
from django.contrib.auth.models import User

# 1. User Profile Model (Points aur Leaderboard ke liye)
class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    total_points = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    def __cl_profile__(self):
        return f"{self.user.username} - {self.total_points} Points"

# 2. Scan History Model (Har ek scan ka record rakhne ke liye)
class ScanHistory(models.Model):
    user_profile = models.ForeignKey(UserProfile, on_delete=models.CASCADE, related_name='scans')
    waste_type = models.CharField(max_length=100)  # Jaise Plastic Bottle, Cardboard, etc.
    bin_color = models.CharField(max_length=50)    # Blue, Green, Yellow Bin
    points_earned = models.IntegerField()
    scanned_at = models.DateTimeField(auto_now_add=True)

    def __cl_scan__(self):
        return f"{self.user_profile.user.username} scanned {self.waste_type}"

from django.urls import path
from .views import login_api, signup_api, predict_waste

urlpatterns = [
    path('login/', login_api, name='login_api'),
    path('signup/', signup_api, name='signup_api'),
    path('predict/', predict_waste, name='predict_waste'),
]
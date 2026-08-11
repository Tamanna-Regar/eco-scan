from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import authenticate
from django.contrib.auth.models import User

# --- Login API ---
@api_view(['POST'])
def login_api(request):
    username = request.data.get('username')
    password = request.data.get('password')
    if not username or not password:
        return Response({"error": "Please provide both", "status": "failed"}, status=status.HTTP_400_BAD_REQUEST)
    user = authenticate(username=username, password=password)
    if user is not None:
        return Response({"message": "Login successful!", "status": "success"}, status=status.HTTP_200_OK)
    return Response({"error": "Invalid credentials", "status": "failed"}, status=status.HTTP_401_UNAUTHORIZED)

# --- Signup API ---
@api_view(['POST'])
def signup_api(request):
    username = request.data.get('username')
    email = request.data.get('email')
    password = request.data.get('password')
    if not username or not email or not password:
        return Response({"error": "All fields required", "status": "failed"}, status=status.HTTP_400_BAD_REQUEST)
    if User.objects.filter(username=username).exists():
        return Response({"error": "User exists", "status": "failed"}, status=status.HTTP_400_BAD_REQUEST)
    user = User.objects.create_user(username=username, email=email, password=password)
    return Response({"message": "Account created!", "status": "success"}, status=status.HTTP_201_CREATED)

# --- Predict Waste API (NEW) ---
@api_view(['POST'])
def predict_waste(request):
    if 'image' not in request.FILES:
        return Response({"error": "No image uploaded", "status": "failed"}, status=status.HTTP_400_BAD_REQUEST)
    
    # Yahan AI Model ka result aayega
    return Response({
        "status": "success",
        "prediction": "Plastic Waste",
        "message": "Image scanned successfully!"
    }, status=status.HTTP_200_OK)
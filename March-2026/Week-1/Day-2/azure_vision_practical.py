"""
Azure Computer Vision + Laptop Camera Integration
Real-time image capture and analysis 
Author: S Manoj Gowda
Date:  03/03/2026
"""

import cv2
import os
import time
from azure.cognitiveservices.vision.computervision import ComputerVisionClient
from msrest.authentication import CognitiveServicesCredentials
from PIL import Image
import io

# ===== AZURE CONFIGURATION =====
ENDPOINT = os.getenv("AZURE_COMPUTER_VISION_ENDPOINT")
KEY = os.getenv("AZURE_COMPUTER_VISION_KEY")

# Initialize Azure Vision client
credentials = CognitiveServicesCredentials(KEY)
client = ComputerVisionClient(ENDPOINT, credentials)

# Create folder to store captured images
CAPTURE_FOLDER = "captured_images"
if not os.path.exists(CAPTURE_FOLDER):
    os.makedirs(CAPTURE_FOLDER)

# ===== FUNCTION 1: CAPTURE IMAGE FROM CAMERA =====
def capture_image_from_camera():
    """
    Captures an image from laptop camera
    Press SPACE to capture, ESC to exit
    """
    print("\n" + "="*70)
    print("📷 CAMERA CAPTURE MODE")
    print("="*70)
    print("Instructions:")
    print("  ► Press SPACE to capture image")
    print("  ► Press ESC to exit camera")
    print("="*70 + "\n")
    
    # Initialize webcam
    cap = cv2.VideoCapture(0)
    
    if not cap.isOpened():
        print("❌ Error: Could not access camera. Check if camera is available.")
        return None
    
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
    
    captured_image_path = None
    
    while True:
        ret, frame = cap.read()
        
        if not ret:
            print("❌ Error: Could not read frame from camera")
            break
        
        # Display live feed with instructions
        cv2.putText(frame, "Press SPACE to capture | ESC to exit", (10, 30),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 0), 2)
        cv2.imshow("Camera Feed - Azure Vision Practical", frame)
        
        key = cv2.waitKey(1) & 0xFF
        
        if key == 32:  # SPACE key
            timestamp = time.strftime("%Y%m%d_%H%M%S")
            captured_image_path = os.path.join(CAPTURE_FOLDER, f"capture_{timestamp}.jpg")
            cv2.imwrite(captured_image_path, frame)
            print(f"✓ Image captured: {captured_image_path}")
            break
        
        elif key == 27:  # ESC key
            print("Camera closed by user")
            break
    
    cap.release()
    cv2.destroyAllWindows()
    
    return captured_image_path

# ===== FUNCTION 2: ANALYZE IMAGE FROM FILE =====
def analyze_local_image(image_path):
    """Analyze image from local file using Azure Vision"""
    print(f"\n{'='*70}")
    print(f" ANALYZING IMAGE: {os.path.basename(image_path)}")
    print(f"{'='*70}\n")
    
    try:
        with open(image_path, "rb") as image_file:
            analysis = client.analyze_image_in_stream(
                image_file,
                visual_features=[
                    "categories",
                    "description",
                    "tags",
                    "objects",
                    "color",
                    "faces"
                ]
            )
        
        display_analysis_results(analysis)
        return analysis
    
    except Exception as e:
        print(f"❌ Error analyzing image: {str(e)}")
        return None

# ===== FUNCTION 3: DISPLAY ANALYSIS RESULT =====
def display_analysis_results(analysis):
    """Display comprehensive analysis results"""
    
    # Image Caption
    print("📸 IMAGE CAPTION & DESCRIPTION:")
    if analysis.description.captions:
        for caption in analysis.description.captions:
            print(f"  ► {caption.text}")
            print(f"    Confidence: {caption.confidence:.2%}\n")
    
    # Image Tags
    print("🏷️  DETECTED TAGS (Top 10):")
    if analysis.tags:
        for i, tag in enumerate(analysis.tags[:10], 1):
            print(f"  {i}. {tag.name}: {tag.confidence:.2%}")
    print()
    
    # Detected Objects
    print("🔍 DETECTED OBJECTS:")
    if analysis.objects:
        for obj in analysis.objects[:8]:
            obj_name = getattr(obj, 'object_property', getattr(obj, 'object_name', 'Unknown'))
            rect = obj.rectangle
            print(f"  ► {obj_name} (Confidence: {obj.confidence:.0%})")
            print(f"    Position: X={rect.x}, Y={rect.y}, Width={rect.w}, Height={rect.h}")
    else:
        print("  ► No objects detected")
    print()
    
    # Color Analysis
    print("🎨 COLOR ANALYSIS:")
    if analysis.color:
        print(f"  ► Dominant Colors: {', '.join(analysis.color.dominant_colors)}")
        print(f"  ► Accent Color: #{analysis.color.accent_color}")
        print(f"  ► Is B&W Image: {analysis.color.is_bw_img}")
        print(f"  ► Is B&W + Color: {analysis.color.is_bw_img}\n")
    
    # Face Detection
    print("👤 FACE DETECTION:")
    if analysis.faces:
        print(f"  ► Total Faces Found: {len(analysis.faces)}")
        for i, face in enumerate(analysis.faces, 1):
            print(f"    Face {i}:")
            print(f"      - Age: ~{face.face_attributes.age} years")
            print(f"      - Gender: {face.face_attributes.gender}")
            print(f"      - Position: X={face.face_rectangle.left}, Y={face.face_rectangle.top}")
    else:
        print("  ► No faces detected in image\n")
    
# ===== FUNCTION 4: SAVE RESULTS TO FILE =====
def save_results_to_file(image_path, analysis):
    """Save analysis results to a text file"""
    timestamp = time.strftime("%Y%m%d_%H%M%S")
    results_file = os.path.join(CAPTURE_FOLDER, f"analysis_{timestamp}.txt")
    
    try:
        with open(results_file, 'w', encoding='utf-8') as f:
            f.write("="*70 + "\n")
            f.write("AZURE COMPUTER VISION ANALYSIS RESULTS\n")
            f.write("="*70 + "\n\n")
            f.write(f"Image: {os.path.basename(image_path)}\n")
            f.write(f"Analysis Time: {timestamp}\n\n")
            
            # Caption
            if analysis.description.captions:
                f.write("CAPTION:\n")
                for caption in analysis.description.captions:
                    f.write(f"  {caption.text} (Confidence: {caption.confidence:.2%})\n\n")
            
            # Tags
            if analysis.tags:
                f.write("DETECTED TAGS:\n")
                for tag in analysis.tags[:10]:
                    f.write(f"  - {tag.name}: {tag.confidence:.2%}\n")
                f.write("\n")
            
            # Objects
            if analysis.objects:
                f.write("DETECTED OBJECTS:\n")
                for obj in analysis.objects[:8]:
                    obj_name = getattr(obj, 'object_property', 'Unknown')
                    f.write(f"  - {obj_name}: {obj.confidence:.0%}\n")
                f.write("\n")
            
            # Colors
            if analysis.color:
                f.write("COLOR ANALYSIS:\n")
                f.write(f"  Dominant Colors: {', '.join(analysis.color.dominant_colors)}\n")
                f.write(f"  Accent Color: {analysis.color.accent_color}\n\n")
            
            # Faces
            if analysis.faces:
                f.write(f"FACES DETECTED: {len(analysis.faces)}\n")
                for i, face in enumerate(analysis.faces, 1):
                    f.write(f"  Face {i}: Age ~{face.face_attributes.age}, Gender: {face.face_attributes.gender}\n")
            else:
                f.write("FACES DETECTED: 0\n")
        
        print(f"✓ Results saved to: {results_file}")
        return results_file
    
    except Exception as e:
        print(f"❌ Error saving results: {str(e)}")
        return None

def main_menu():
    # ... (rest of the main_menu logic from azure_vision_practical.py)
    pass

if __name__ == "__main__":
    main_menu()
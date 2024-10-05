from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
from PIL import Image
import io
app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.post("/inspectfirstimage/")
async def validate_image(file: UploadFile = File(...)):
    try:
        # 이미지 파일 읽기
        contents = await file.read()
        image = Image.open(io.BytesIO(contents))

        # AI 모델을 통해 이미지 검증 (예시, 실제 검증 코드 작성)
        result = image

        return JSONResponse(content={"result": result})

    except Exception as e:
        return JSONResponse(content={"error": str(e)}, status_code=400)
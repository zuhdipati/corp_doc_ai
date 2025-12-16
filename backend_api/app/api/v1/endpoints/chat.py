from fastapi import APIRouter, HTTPException
from app.models.chat import ChatRequest, ChatResponse
# from app.services.chatbot import ChatBotService

router = APIRouter()

@router.post("/query", response_model=ChatResponse)
async def chat_with_docs(req: ChatRequest):
    try:
        simulated_answer = f"jawaban simulasi untuk: {req.question}"
        
        return ChatResponse(
            answer=simulated_answer,
        )

        # start = time.time()
        # result = qa.invoke({"question": req.question, "chat_history": req.chat_history})
        # answer = result.get("answer") or result.get("result") or str(result)

        # req.chat_history.append((req.question, answer))
        # if len(req.chat_history) > 5:
        #     req.chat_history = req.chat_history[-5:]

        # print(f"Jawaban selesai dalam {round(time.time() - start, 2)} detik")
        # return {"answer": answer, "history": req.chat_history}

    except Exception as e:
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))
    
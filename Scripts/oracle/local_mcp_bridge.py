import httpx
from mcp.server.fastmcp import FastMCP

# Initialize FastMCP server
mcp = FastMCP("LocalOracle")

OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL_NAME = "qwen3:8b"  # matches `ollama list` output

@mcp.tool()
async def query_qwen(prompt: str) -> str:
    """
    Sends a prompt to the local Qwen3 model via Ollama and returns the response.
    Use this for literature summarization, notation mapping, or initial draft generation.
    """
    payload = {
        "model": MODEL_NAME,
        "prompt": prompt,
        "stream": False
    }

    async with httpx.AsyncClient() as client:
        try:
            response = await client.post(OLLAMA_URL, json=payload, timeout=60.0)
            response.raise_for_status()
            return response.json().get("response", "No response from model.")
        except Exception as e:
            return f"Error connecting to Ollama: {str(e)}"

if __name__ == "__main__":
    mcp.run()

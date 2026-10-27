import OpenAI from 'openai';
import express from 'express';

const router = express.Router();

const client = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

router.post('/ai/suggest', async (req, res) => {
  const { ingredients = [], preferences = {} } = req.body;

  if (!Array.isArray(ingredients) || ingredients.length === 0) {
    return res.status(400).json({ error: 'Нет ингредиентов' });
  }

  try {
    const prompt = `
Ты кулинарный помощник.
Подбери 3 простых рецепта, используя ТОЛЬКО эти ингредиенты:
${ingredients.join(', ')}

Условия:
- Приём пищи: ${preferences.meal || 'любой'}
- Вегетарианство: ${preferences.vegetarian ? 'да' : 'нет'}

Ответ верни СТРОГО в JSON без пояснений и текста:
[
  {
    "title": "Название блюда",
    "ingredients": ["ингредиент1", "ингредиент2"],
    "steps": ["шаг 1", "шаг 2"]
  }
]
`;

    const completion = await client.chat.completions.create({
      model: 'gpt-4.1-mini',
      messages: [
        { role: 'system', content: 'Ты ИИ для подбора рецептов' },
        { role: 'user', content: prompt }
      ],
      temperature: 0.5,
      max_tokens: 500,
    });

    const text = completion.choices[0].message.content;

    let recipes;
    try {
      recipes = JSON.parse(text);
    } catch (e) {
      console.error('❌ JSON parse error:', text);
      return res.status(500).json({ error: 'ИИ вернул некорректный JSON' });
    }

    res.json(recipes);

  } catch (err) {
    console.error('❌ OpenAI error:', err?.message || err);
    res.status(500).json({ error: 'Ошибка ИИ' });
  }
});

export default router;

// server.js
import express from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';
import sqlite3 from 'sqlite3';
import { open } from 'sqlite';
import 'dotenv/config';
import aiRecipes from './routes/aiRecipes.js';

const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use('/api', aiRecipes);

let db;
(async () => {
  db = await open({
    filename: './users.db',
    driver: sqlite3.Database
  });

  // users
  await db.exec(`
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL
    );
  `);

  // favorites
  await db.exec(`
    CREATE TABLE IF NOT EXISTS favorites (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      recipe_id TEXT NOT NULL,
      title TEXT NOT NULL,
      image TEXT,
      ingredients TEXT,
      steps TEXT,
      FOREIGN KEY (user_id) REFERENCES users(id)
    );
  `);

  await db.exec(`
    CREATE TABLE IF NOT EXISTS ai_usage (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      date TEXT,
      calls INTEGER DEFAULT 0,
      UNIQUE(user_id, date)
    );
  `);


  // recipes
  await db.exec(`
    CREATE TABLE IF NOT EXISTS recipes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      recipe_id TEXT UNIQUE NOT NULL,
      title TEXT NOT NULL,
      image TEXT,
      ingredients TEXT, -- JSON array
      steps TEXT,       -- JSON array
      tags TEXT         -- JSON array or comma separated
    );
  `);

  console.log('✅ DB ready');

// ---------- Заполнение базы рецептов (seed) ----------
const count = await db.get('SELECT COUNT(*) as c FROM recipes');
if (count && count.c === 0) {
  const seed = [
    {
      recipe_id: 'omelette_01',
      title: 'Омлет с творогом',
      image: 'https://cdn.pixabay.com/photo/2016/03/05/22/42/omelet-1238569_1280.jpg',
      ingredients: ['eggs', 'milk', 'cottage_cheese', 'salt', 'butter'],
      steps: ['Взбить яйца', 'Добавить молоко и творог', 'Обжарить на масле']
    },
    {
      recipe_id: 'pancakes_01',
      title: 'Панкейки на молоке',
      image: 'https://cdn.pixabay.com/photo/2017/05/07/08/56/pancakes-2291908_1280.jpg',
      ingredients: ['milk', 'egg', 'flour', 'sugar', 'salt', 'butter'],
      steps: ['Смешать ингредиенты', 'Жарить на сковороде']
    },
    {
      recipe_id: 'cottage_cheese_salad',
      title: 'Салат с творогом',
      image: 'https://cdn.pixabay.com/photo/2017/04/04/20/57/salad-2200034_1280.jpg',
      ingredients: ['cottage_cheese', 'tomato', 'cucumber', 'olive_oil', 'salt'],
      steps: ['Нарезать овощи', 'Смешать с творогом', 'Заправить маслом']
    },
    {
      recipe_id: 'pasta_01',
      title: 'Паста с сыром',
      image: 'https://cdn.pixabay.com/photo/2016/03/05/19/02/spaghetti-1238644_1280.jpg',
      ingredients: ['pasta', 'cheese', 'butter', 'salt'],
      steps: ['Отварить пасту', 'Добавить масло и сыр']
    },
    {
      recipe_id: 'soup_01',
      title: 'Куриный суп',
      image: 'https://cdn.pixabay.com/photo/2014/12/15/13/40/soup-569069_1280.jpg',
      ingredients: ['chicken', 'potato', 'carrot', 'onion', 'salt', 'water'],
      steps: ['Отварить курицу', 'Добавить овощи и варить до готовности']
    },
    {
      recipe_id: 'smoothie_01',
      title: 'Фруктовый смузи',
      image: 'https://cdn.pixabay.com/photo/2016/11/29/09/15/smoothie-1869698_1280.jpg',
      ingredients: ['banana', 'milk', 'berries', 'honey'],
      steps: ['Смешать все ингредиенты в блендере']
    },
    {
      recipe_id: 'sandwich_01',
      title: 'Сэндвич с яйцом и сыром',
      image: 'https://cdn.pixabay.com/photo/2017/03/27/13/54/sandwich-2178742_1280.jpg',
      ingredients: ['bread', 'egg', 'cheese', 'butter'],
      steps: ['Обжарить хлеб', 'Добавить яйцо и сыр']
    },
    {
      recipe_id: 'salad_veggie',
      title: 'Овощной салат',
      image: 'https://cdn.pixabay.com/photo/2016/08/23/15/48/salad-1610974_1280.jpg',
      ingredients: ['tomato', 'cucumber', 'onion', 'olive_oil', 'salt'],
      steps: ['Нарезать овощи', 'Заправить маслом и солью']
    },
    {
      recipe_id: 'porridge_01',
      title: 'Овсянка с фруктами',
      image: 'https://cdn.pixabay.com/photo/2016/07/28/02/09/oatmeal-1545788_1280.jpg',
      ingredients: ['oats', 'milk', 'banana', 'apple', 'honey'],
      steps: ['Сварить овсянку', 'Добавить фрукты и мёд']
    },
    {
      recipe_id: 'pizza_01',
      title: 'Домашняя пицца',
      image: 'https://cdn.pixabay.com/photo/2017/12/09/08/18/pizza-3007395_1280.jpg',
      ingredients: ['flour', 'tomato_sauce', 'cheese', 'ham', 'olive_oil'],
      steps: ['Замесить тесто', 'Добавить начинку', 'Запечь в духовке']
    },
    {
      recipe_id: 'cutlets_01',
      title: 'Котлеты из курицы',
      image: 'https://cdn.pixabay.com/photo/2021/01/22/09/47/chicken-cutlet-5939407_1280.jpg',
      ingredients: ['chicken', 'egg', 'bread_crumbs', 'salt', 'oil'],
      steps: ['Сформировать котлеты', 'Обжарить на сковороде']
    }
  ];

  for (const r of seed) {
    await db.run(
      'INSERT INTO recipes (recipe_id, title, image, ingredients, steps) VALUES (?, ?, ?, ?, ?)',
      [r.recipe_id, r.title, r.image, JSON.stringify(r.ingredients), JSON.stringify(r.steps)]
    );
  }

  console.log('✅ Recipes seeded successfully!');
}
})();

// --- рег и логин (как было) ---
// регистрация
app.post('/register', async (req, res) => {
  const { name, email, password } = req.body;
  if (!name || !email || !password) return res.status(400).send('All fields required');
  try {
    const result = await db.run('INSERT INTO users (name,email,password) VALUES (?,?,?)', [name, email, password]);
    const user = await db.get('SELECT id, name, email FROM users WHERE id = ?', [result.lastID]);
    res.status(201).json({ message: 'registered', user });
  } catch (err) {
    console.error(err);
    res.status(500).send('Error');
  }
});

// login
app.post('/login', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).send('All fields required');
  try {
    const user = await db.get('SELECT * FROM users WHERE email = ? AND password = ?', [email, password]);
    if (!user) return res.status(401).send('Неверный email или пароль');
    res.json({ message: 'ok', user: { id: user.id, name: user.name, email: user.email }});
  } catch (err) {
    console.error(err);
    res.status(500).send('Error');
  }
});

// get user by id
app.get('/users/:id', async (req, res) => {
  const id = req.params.id;
  try {
    const user = await db.get('SELECT id, name, email FROM users WHERE id = ?', [id]);
    if (!user) return res.status(404).send('User not found');
    res.json(user);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error');
  }
});

// --- Recipes endpoints
app.get('/recipes', async (req, res) => {
  try {
    const rows = await db.all('SELECT * FROM recipes');
    const parsed = rows.map(r => ({
      id: r.id,
      recipe_id: r.recipe_id,
      title: r.title,
      image: r.image,
      ingredients: JSON.parse(r.ingredients || '[]'),
      steps: JSON.parse(r.steps || '[]'),
      tags: JSON.parse(r.tags || '[]')
    }));
    res.json(parsed);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error');
  }
});

app.get('/recipes/:id', async (req, res) => {
  const id = req.params.id;
  try {
    const r = await db.get('SELECT * FROM recipes WHERE id = ? OR recipe_id = ?', [id, id]);
    if (!r) return res.status(404).send('Not found');
    res.json({
      id: r.id,
      recipe_id: r.recipe_id,
      title: r.title,
      image: r.image,
      ingredients: JSON.parse(r.ingredients || '[]'),
      steps: JSON.parse(r.steps || '[]'),
      tags: JSON.parse(r.tags || '[]')
    });
  } catch (err) {
    console.error(err);
    res.status(500).send('Error');
  }
});

// POST /recipes/suggest
// body: { ingredients: ['eggs','milk'], preferences: { meal: 'breakfast', vegetarian: false } }
app.post('/recipes/suggest', async (req, res) => {
  const { ingredients = [], preferences = {} } = req.body;
  try {
    const rows = await db.all('SELECT * FROM recipes');
    // простой алгоритм: считаем пересечение ингредиентов
    const ingLower = ingredients.map(x => (''+x).toLowerCase().trim());
    const scored = rows.map(r => {
      const recIngs = JSON.parse(r.ingredients || '[]').map(x => (''+x).toLowerCase().trim());
      const common = recIngs.filter(x => ingLower.includes(x)).length;
      const score = common / Math.max(recIngs.length, 1); // доля совпавших
      return {
        id: r.id,
        recipe_id: r.recipe_id,
        title: r.title,
        image: r.image,
        ingredients: recIngs,
        steps: JSON.parse(r.steps || '[]'),
        tags: JSON.parse(r.tags || '[]'),
        score,
        common
      };
    });

    // Можно учитывать preferences (если указаны) — сейчас просто фильтруем по тегам:
    let filtered = scored;
    if (preferences.meal) {
      filtered = filtered.filter(r => (r.tags || []).includes(preferences.meal));
    }
    // Сортируем по score и общему количеству совпадений и возвращаем топ N
    filtered.sort((a,b) => {
      if (b.score === a.score) return b.common - a.common;
      return b.score - a.score;
    });

    // Возвращаем топ 20
    res.json(filtered.slice(0, 20));
  } catch (err) {
    console.error(err);
    res.status(500).send('Error');
  }
});

// --- favorites endpoints (как раньше)
app.post('/favorites', async (req, res) => {
  const { user_id, recipe_id, title, image, ingredients, steps } = req.body;
  if (!user_id || !recipe_id || !title) return res.status(400).send('Недостаточно данных');
  try {
    await db.run(`INSERT INTO favorites (user_id, recipe_id, title, image, ingredients, steps)
                  VALUES (?,?,?,?,?,?)`, [user_id, recipe_id, title, image, JSON.stringify(ingredients), JSON.stringify(steps)]);
    res.status(201).send('Added');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error');
  }
});

app.get('/favorites/:user_id', async (req,res) => {
  const { user_id } = req.params;
  try {
    const favs = await db.all('SELECT * FROM favorites WHERE user_id = ?', [user_id]);
    const parsed = favs.map(f => ({
      ...f,
      ingredients: JSON.parse(f.ingredients || '[]'),
      steps: JSON.parse(f.steps || '[]')
    }));
    res.json(parsed);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error');
  }
});

app.delete('/favorites/:id', async (req,res) => {
  const { id } = req.params;
  try {
    const r = await db.run('DELETE FROM favorites WHERE id = ?', [id]);
    if (r.changes === 0) return res.status(404).send('Not found');
    res.send('Deleted');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error');
  }
});

app.post('/api/recipes/search', async (req, res) => {
  const { ingredients } = req.body;

  if (!ingredients || ingredients.length === 0) {
    return res.status(400).json({ message: 'Не указаны ингредиенты' });
  }

  const all = await db.all('SELECT * FROM recipes');
  const parsed = all.map(r => ({
    ...r,
    ingredients: JSON.parse(r.ingredients),
    steps: JSON.parse(r.steps)
  }));

  // Фильтруем по совпадениям ингредиентов
  const results = parsed.filter(r =>
    r.ingredients.some(i => ingredients.includes(i))
  );

  res.json(results);
});


app.listen(3000, () => {
  console.log('Server started on http://localhost:3000');
});

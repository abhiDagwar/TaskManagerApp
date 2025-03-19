const express = require('express');
const admin = require('firebase-admin');
const cors = require('cors');
require('dotenv').config();

// Initialize Firebase Admin
const serviceAccount = require(process.env.FIREBASE_ADMIN_KEY);
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const app = express();
// app.js
app.use(cors({
    origin: 'http://localhost:8080', // Your iOS app's origin
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());

// Health Check Endpoint
app.get('/', (req, res) => {
  res.send('Task Manager API is running!');
});

// Validate MongoDB ID format
app.param('id', (req, res, next, id) => {
    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(400).json({ error: "Invalid task ID" });
    }
    next();
});

// Fetch All Tasks for a User
app.get('/tasks/:userId', async (req, res) => {
  try {
    const userId = req.params.userId;
    const tasksRef = db.collection('users').doc(userId).collection('tasks');
    const snapshot = await tasksRef.get();
    const tasks = [];
    snapshot.forEach(doc => {
      tasks.push({ id: doc.id, ...doc.data() });
    });
    res.status(200).json(tasks);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch tasks' });
  }
});

// Create a New Task
app.post('/tasks/:userId', async (req, res) => {
  try {
    const userId = req.params.userId;
    const { title, description, dueDate, status } = req.body;
    const taskRef = await db.collection('users').doc(userId).collection('tasks').add({
      title,
      description,
      dueDate: new Date(dueDate),
      status: status || 'Todo',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    res.status(201).json({ id: taskRef.id, message: 'Task created!' });
  } catch (error) {
    res.status(500).json({ error: 'Failed to create task' });
  }
});

// PUT /tasks/:id
// Update an Existing Task
app.put('/tasks/:userId/:taskId', async (req, res) => {
    try {
        const { userId, taskId } = req.params;
        const { title, description, dueDate, status } = req.body;

        const taskRef = db.collection('users').doc(userId).collection('tasks').doc(taskId);

        const taskSnapshot = await taskRef.get();
        if (!taskSnapshot.exists) {
            return res.status(404).json({ error: "Task not found" });
        }

        await taskRef.update({
            title,
            description,
            dueDate: new Date(dueDate),
            status
        });

        res.json({ id: taskId, message: "Task updated successfully" });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// Start Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Backend running on http://localhost:${PORT}`);
});

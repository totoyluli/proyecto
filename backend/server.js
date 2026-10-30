// backend/server.js
const express = require('express');
const cors = require('cors');
const app = express();

// CRÍTICO: Ampliar el límite para aceptar JSON gigantes de coordenadas
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));
app.use(cors());
// Configuración de la base de datos MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',      // Reemplaza con tu usuario de MySQL
  password: '',      // Reemplaza con tu contraseña de MySQL
  database: 'lenguaje_señas'
});

db.connect((err) => {
  if (err) {
    console.error('Error conectando a la base de datos:', err);
    return;
  }
  console.log('Conexión exitosa a la base de datos MySQL');
});

// Ruta (API) para guardar una muestra en la BD (CREATE / INSERT)
app.post('/api/guardar-modelo', (req, res) => {
    const { id_usuario, nombre_modelo, archivo_json } = req.body;

    // Si 'archivo_json' viene como objeto, asegúrate de pasarlo a string:
    const jsonString = typeof archivo_json === 'object' ? JSON.stringify(archivo_json) : archivo_json;

    const query = "INSERT INTO modelos (id_usuario, nombre_modelo, archivo_json, es_activo) VALUES (?, ?, ?, 1)";

    db.query(query, [id_usuario, nombre_modelo, jsonString], (err, resultado) => {
        if (err) {
            console.error("Error al guardar en MySQL:", err);
            return res.status(500).json({ error: err.message });
        }
        res.json({ mensaje: "¡Modelo guardado con éxito en la base de datos!", id: resultado.insertId });
    });
});

// Iniciar el servidor
app.listen(port, () => {
  console.log(`Servidor backend corriendo en http://localhost:${port}`);
});
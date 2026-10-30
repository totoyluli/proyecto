// frontend/app.js

const btnCargar = document.getElementById('btnCargar');
const divResultado = document.getElementById('resultado');

// Función asíncrona para cargar el modelo JSON y enviarlo al backend[cite: 3]
const procesarYGuardarModelo = async () => {
  try {
    divResultado.innerHTML = 'Cargando archivo JSON...';

    // 1. Obtiene el archivo JSON localizado en la carpeta principal
    // (Asegúrate de que la ruta sea correcta según donde corras el HTML)
    const respuesta = await fetch('../modelo_senas (13).json'); 
    const datos = await respuesta.json();

    // 2. Lee las muestras para una seña (por ejemplo, la letra 'A')
    const muestrasA = datos['A'];
    let cantidadMuestras = muestrasA ? muestrasA.length : 0; // Variable reasignable[cite: 4]
    
    divResultado.innerHTML = `Se encontraron ${cantidadMuestras} muestras para 'A'. Guardando en BD...`;

    // 3. Simula guardar la primera muestra de 'A' en la BD
    if (cantidadMuestras > 0) {
        const muestraParaGuardar = {
            id_modelo: 1, // Asumimos que existe un modelo con ID 1 en la BD
            etiqueta_letra: 'A',
            vector_landmarks: muestrasA[0] // Mandamos el primer vector
        };

        // Enviar datos al backend mediante fetch POST
        const resGuardar = await fetch('http://localhost:3000/api/guardar-muestra', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(muestraParaGuardar)
        });

        if (resGuardar.ok) {
            const dataBackend = await resGuardar.json();
            divResultado.innerHTML = `<p style="color:green;">¡Éxito! ${dataBackend.mensaje} (ID: ${dataBackend.id})</p>`;
        } else {
             divResultado.innerHTML = `<p style="color:red;">Error al guardar en la BD.</p>`;
        }
    }

  } catch (error) {
    console.error("Error en el proceso:", error);
    divResultado.innerHTML = `<p style="color:red;">Ocurrió un error. Revisa la consola.</p>`;
  }
};

// Asigna la ejecución de la función al botón[cite: 3]
btnCargar.addEventListener('click', procesarYGuardarModelo);
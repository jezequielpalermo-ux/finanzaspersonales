# 🚀 Setup — Control de Gastos (GitHub + Supabase + Vercel)

## Arquitectura (igual que Muuk App)

```
GitHub repo  →  Vercel (host estático)
                     ↕ fetch REST
               Supabase (base de datos)
```

Un solo archivo `index.html`. Sin backend. Sin `package.json`.
Supabase se llama directamente desde el browser con la anon key — igual que Muuk.

---

## Paso 1 — Crear proyecto en Supabase

1. Ir a [supabase.com](https://supabase.com) → **New project**
2. Elegir nombre, región y contraseña
3. Esperar que termine de provisionar (~1 min)

---

## Paso 2 — Crear las tablas (SQL Editor)

1. En el proyecto de Supabase → **SQL Editor → New query**
2. Pegar el contenido de `schema.sql` y ejecutar (**Run**)

Esto crea:
- `gastos_state` — tabla principal (1 fila, todo el estado en JSON)
- `gastos_versions` — historial de versiones para recuperación

---

## Paso 3 — Copiar las credenciales

1. En Supabase → **Settings → API**
2. Copiar los dos valores:
   - **Project URL** → `https://xxxx.supabase.co`
   - **anon / public key** → `eyJhbGci...`

---

## Paso 4 — Subir el código a GitHub

1. Crear un repo nuevo (o usar el que ya tenés)
2. Subir estos 4 archivos:
   ```
   index.html
   schema.sql
   vercel.json
   .gitignore
   ```

---

## Paso 5 — Deploy en Vercel

1. Ir a [vercel.com](https://vercel.com) → **Add New Project**
2. Importar el repo de GitHub
3. **No hace falta configurar nada** — Vercel detecta automáticamente que es HTML estático
4. Clic en **Deploy**
5. En ~30 segundos obtenés una URL como `https://control-gastos-xxx.vercel.app`

> No hay variables de entorno que configurar en Vercel — las credenciales de Supabase se ingresan dentro de la app.

---

## Paso 6 — Configurar Supabase dentro de la app

1. Abrir la URL de Vercel
2. Ir a la pestaña ⚙️ **Config**
3. En la card "☁️ Base de datos Supabase", pegar:
   - **Project URL** (del Paso 3)
   - **Anon Key** (del Paso 3)
4. La app guarda estos datos en `localStorage` del dispositivo
5. A partir de ese momento todos los cambios se sincronizan automáticamente

> Las credenciales quedan guardadas por dispositivo. En un dispositivo nuevo hay que ingresarlas una vez.

---

## Paso 7 — Agregar al celular como app

**iPhone (Safari):**
1. Abrir la URL en Safari → ícono compartir → "Agregar a pantalla de inicio"

**Android (Chrome):**
1. Abrir la URL en Chrome → menú ⋮ → "Instalar app"

---

## Cómo funciona la sincronización

| Acción | Comportamiento |
|--------|----------------|
| Abrir la app | Carga localStorage (instantáneo) + busca en Supabase |
| Agregar / editar / eliminar | Guarda en localStorage + sube a Supabase |
| Sin internet | Guarda local, sube cuando vuelve la conexión |
| Nuevo dispositivo | Baja todo desde Supabase al ingresar las credenciales |
| ⚙️ "Restaurar desde nube" | Fuerza una bajada completa desde Supabase |

---

## Estructura de datos

Todo se guarda como un único objeto JSON en la columna `data` de `gastos_state`:

```json
{
  "config": {
    "tarjeta": ["Visa Banco Galicia", "..."],
    "fijo": ["Expensas"],
    "variable": ["Entretenimiento", "Salud"],
    "efectivo": ["Comida", "Varios"]
  },
  "tarjetas": [{ "id": 1234, "tarjeta": "Visa Galicia", "fecha": "2026-04-01", "monto": 150000, ... }],
  "gastosFijos": [...],
  "gastosVariables": [...],
  "efectivo": [...],
  "pdfHistory": [...]
}
```

---

## Actualizar el código

1. Editar `index.html` en GitHub
2. Vercel redeploya automáticamente en ~30 segundos
3. La URL no cambia

---

## Troubleshooting

**Badge muestra "Sin Supabase":**
→ Ir a ⚙️ Config y completar URL y anon key

**Badge muestra "Error":**
→ Verificar que el SQL de `schema.sql` se ejecutó correctamente
→ Verificar que RLS policies están habilitadas (el SQL las crea automáticamente)

**Los datos no aparecen en otro dispositivo:**
→ En el nuevo dispositivo, ir a ⚙️ Config, ingresar las credenciales y tocar "Restaurar desde nube"

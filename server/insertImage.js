const express = require("express");
const pool = require('./db.config');

const insertImageRouter = express.Router();

insertImageRouter.post('/insert_image', async (req,res) => {
    const createdAt = new Date().toISOString().slice(0, 10);
    const { image_name, image_path, created_by } = req.body;
    try {
        const query = `
        INSERT INTO public.table_oss(image_name,image_path,image_metadata,created_at,created_by)
        VALUES ($1,$2,$3,$4,$5);
        `;
        const values = [
            image_name,
            image_path,
            'Ignore',
            createdAt,
            created_by
        ];

        await pool.query(query, values);

        res.json({
            message: 'successfully insert a row.',
            inserted_at: createdAt
        })
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal server error, in insertImage.js file');
    }
});

module.exports = insertImageRouter;
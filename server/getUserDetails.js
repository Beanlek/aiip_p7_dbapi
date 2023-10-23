const express = require("express");
const pool = require('./db.config');

const getUserDetailsRouter = express.Router();

getUserDetailsRouter.get('/', async (req,res) => {
    const createdAt = new Date().toISOString().slice(0, 10);
    try {
        const query = `
        select * from user_details ud;
        `;
        // const query = `
        // select * from user_details ud where email='imran@gmail.com';
        // `;

        await pool.query(query, (err,ress) => {
            if (err) {
                console.log(`Error in getUserDetails.js: `, err);
                res.status(500).send(`Error in getUserDetails.js file: ${err}`);
                return;
            }
            // console.log(`Response achieved: `, ress);
            res.json(ress.rows);
            return;

        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Internal server error, in getUserDetails.js file');
    }
});

module.exports = getUserDetailsRouter;
const pool = require('../config/db');

const listarUsuarios = async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM usuarios ORDER BY id ASC');
        res.status(200).json(result.rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({ erro: 'Erro ao buscar usuários' });
    }
};

const criarUsuario = async (req, res) => {
    const { nome, email } = req.body;
    try {
        const query = 'INSERT INTO usuarios (nome, email) VALUES ($1, $2) RETURNING *';
        const result = await pool.query(query, [nome, email]);
        res.status(201).json(result.rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ erro: 'Erro ao buscar usuários' });
    }
};

const deletarUsuario = async (req, res) => {
    const { id } = req.params;

    try {
        const result = await pool.query(
            'DELETE FROM usuarios WHERE id = $1 RETURNING *',
            [id]
        );

        if (result.rowCount === 0) {
            return res.status(404).json({ erro: 'Usuário não encontrado' });
        }

        res.json({ mensagem: 'Usuário deletado com sucesso' });
    } catch (error) {
        res.status(500).json({ erro: 'Erro ao deletar usuário' });
    }
};

const atualizarUsuario = async (req, res) => {
    const id = parseInt(req.params.id);
    const { nome, email } = req.body;

    try {
        const result = await pool.query(
            'UPDATE usuarios SET nome = $1, email = $2 WHERE id = $3 RETURNING *',
            [nome, email, id]
        );

        if (result.rowCount === 0) {
            return res.status(404).json({ erro: 'Usuário não encontrado' });
        }

        res.json(result.rows[0]); // melhor retorno
    } catch (error) {
        console.error(error);
        res.status(500).json({ erro: error.message });
    }
};


module.exports = {
    listarUsuarios,
    criarUsuario,
    atualizarUsuario,
    deletarUsuario
};

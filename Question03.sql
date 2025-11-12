
CREATE TABLE post (
    post_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    tags TEXT[],
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_public BOOLEAN DEFAULT TRUE
);

CREATE TABLE post_like (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id) 
);

INSERT INTO post (user_id, content, tags) VALUES
(1, 'Hôm nay tôi đi du lịch ở Đà Nẵng', ARRAY['du lịch', 'Đà Nẵng']),
(2, 'Chia sẻ kinh nghiệm học lập trình SQL', ARRAY['lập trình', 'SQL']),
(3, 'Món ăn ngon ở Hà Nội', ARRAY['ẩm thực', 'Hà Nội']),
INSERT INTO post_like (user_id, post_id) VALUES
(1, 2),
(2, 1),
(3, 1),
(1, 3); 

EXPLAIN ANALYZE SELECT * FROM post WHERE content ILIKE '%du lịch%';

CREATE INDEX idx_post_content ON post USING GIN (to_tsvector('simple', LOWER(content)));
    -- Dùng Lower để chuẩn hóa dữ liệu về dạng chữ thường, tránh phân biệt hoa thường khi tìm kiếm full-text
    -- Tổng hợp các loại chỉ mục GIN
    /*
    + GIN (column gin_trgm_ops): Phù hợp cho tìm kiếm gần đúng hoặc tìm kiếm xâu con
    + GIN (to_tsvector('language', column)): Phù hợp cho tìm kiếm văn bản đầy đủ (full-text search)
    + GIN (jsonb_path_ops): Phù hợp cho tìm kiếm và truy vấn dữ liệu JSONB
    + GIN (array_column): Phù hợp cho tìm kiếm phần tử trong mảng
    */


EXPLAIN ANALYZE SELECT * FROM post WHERE tags @> ARRAY['du lịch'];

CREATE INDEX idx_post_tags ON post USING GIN(tags);



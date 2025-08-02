USE tranlation;

CREATE TABLE Language (
	language_id INT PRIMARY KEY AUTO_INCREMENT,
    language_name NVARCHAR(50),
    language_code NVARCHAR(10)
);

SELECT * FROM Language;

CREATE TABLE Word (
	word_id INT PRIMARY KEY AUTO_INCREMENT,
    text NVARCHAR(250),
    language_id INT,
    phonetic VARCHAR(50),
    audio TEXT,
    FOREIGN KEY (language_id) REFERENCES Language(language_id)
);

SELECT * FROM Word;

CREATE TABLE Translation (
	translation_id INT PRIMARY KEY AUTO_INCREMENT,
    root_word_id INT,
    target_word_id INT,
    type_word VARCHAR(50),
    note TEXT,
    FOREIGN KEY (root_word_id) REFERENCES Word(word_id),
    FOREIGN KEY (target_word_id) REFERENCES Word(word_id)
);

CREATE TABLE Example (
    id INT PRIMARY KEY AUTO_INCREMENT,
    translation_id INT,       
    sentence_root TEXT,
    sentence_target TEXT,     
    FOREIGN KEY (translation_id) REFERENCES Translation(translation_id)
);

INSERT INTO Language(language_name, language_code) VALUES
('Vietnamese', 'vi'),
('English', 'en'),
('Japanese', 'ja');

INSERT INTO Word(text, language_id, phonetic, audio) VALUES 
('học lập trình', 1, 'hɔk ləp ʈʂïŋ', NULL),
('learn programming', 2, '/lɜːrn ˈproʊɡræmɪŋ/', NULL),
('プログラミングを学びます', 3, 'puroguramingu o manabimasu', NULL);

INSERT INTO Translation (root_word_id, target_word_id, type_word, note) VALUES
(4, 5, 'verb', 'Hành động tiếp thu kiến thức'),
(4, 6, 'verb', 'Hành động học tập trong tiếng Nhật');

INSERT INTO Example (translation_id,  sentence_root, sentence_target) VALUES
('Tôi thích học lập trình', 'I like to learn programming'),
('Tôi đang học lập trình', '私はプログラミングを学ぶのが好きです');

SELECT * FROM Language;
SELECT * FROM Word;
SELECT * FROM Translation;
SELECT * FROM Example;

SELECT 
    l.language_name AS ngonngu_goc,
    w1.text AS tu_goc,
    w2.text AS ban_dich,
    t.type_word AS loai_tu,
    t.note AS ghi_chu,
    e.sentence_root AS cau_goc,
    e.sentence_target AS cau_dich
FROM Translation t
JOIN Word w1 ON t.root_word_id = w1.word_id
JOIN Word w2 ON t.target_word_id = w2.word_id
JOIN Language l ON w1.language_id = l.language_id
JOIN Example e ON e.translation_id = t.translation_id;






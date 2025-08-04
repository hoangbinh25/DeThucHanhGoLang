CREATE SCHEMA translation;

USE translation;

-- Ngôn ngữ
CREATE TABLE Language (
	language_id INT PRIMARY KEY AUTO_INCREMENT,
    language_name NVARCHAR(50) NOT NULL,
    language_code NVARCHAR(10) NOT NULL
);

-- Từ loại
CREATE TABLE WordType (
	type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL
);

-- Từ
CREATE TABLE Word (
	word_id INT PRIMARY KEY AUTO_INCREMENT,
    text NVARCHAR(250) NOT NULL,
    language_id INT NOT NULL,
    phonetic NVARCHAR(50),
    audio_url NVARCHAR(255),
    FOREIGN KEY (language_id) REFERENCES Language(language_id)
);

-- Nghĩa của từ
CREATE TABLE Meaning (
	meaning_id INT PRIMARY KEY AUTO_INCREMENT,
    word_id INT NOT NULL,
    type_id INT NOT NULL,
    define TEXT NOT NULL,
    FOREIGN KEY (word_id) REFERENCES Word(word_id),
    FOREIGN KEY (type_id) REFERENCES WordType(type_id)
);

-- Bản dịch
CREATE TABLE Translation (
	translation_id INT PRIMARY KEY AUTO_INCREMENT,
    meaning_id INT NOT NULL,
    target_language_id INT NOT NULL,
    translate_text NVARCHAR(250) NOT NULL,
    translate_define TEXT NOT NULL,
    FOREIGN KEY (meaning_id) REFERENCES Meaning(meaning_id),
	FOREIGN KEY (target_language_id) REFERENCES Language(language_id)
);

-- Ví dụ
CREATE TABLE Example (
    example_id INT PRIMARY KEY AUTO_INCREMENT,
    meaning_id INT NOT NULL,
    example_text TEXT NOT NULL,
    FOREIGN KEY (meaning_id) REFERENCES Meaning(meaning_id)
);

-- Bản dịch ví dụ: Tiếng Anh, Tiếng Nhật 
CREATE TABLE ExampleTranslate (
	ex_translate_id INT PRIMARY KEY AUTO_INCREMENT,
    example_id INT NOT NULL,
    target_language_id INT NOT NULL,
    translated_example TEXT NOT NULL,
	FOREIGN KEY (example_id) REFERENCES Example(example_id),
    FOREIGN KEY (target_language_id) REFERENCES Language(language_id) 
);

INSERT INTO Language(language_name, language_code) VALUES
('Vietnamese', 'vi'),
('English', 'en'),
('Japanese', 'ja');

INSERT INTO WordType(type_name) VALUES 
('danh từ'),
('tính từ'),
('động từ');

-- Tiếng Việt 
INSERT INTO Word(text, language_id, phonetic) VALUES 
('đông', 1, 'ɗəwŋ͡m˧˧'),
('mùa đông', 1, 'muə˨˩ ɗəwŋ͡m˧˧'),
('đông đúc', 1, 'ɗəwŋ͡m˧˧ ɗʊwk͡p̚˧');

-- Tiếng Anh
INSERT INTO Word(text, language_id, phonetic) VALUES 
('winter', 2, '/ˈwɪn.tər/'),
('crowded', 2, '/ˈwɪn.tər/'),
('east', 2, '/iːst/');

-- Tiếng Nhật
INSERT INTO Word (text, language_id, phonetic) VALUES
('冬', 3, 'ふゆ'),  -- mùa đông
('賑やか', 3, 'にぎやか'), -- đông đúc
('東', 3, 'ひがし'); -- phía đông

-- Nghĩa
INSERT INTO Meaning (word_id, type_id, define) VALUES
(1, 1, 'mùa đông, thời kỳ lạnh nhất trong năm'),
(1, 2, 'đông đúc, nhiều người tụ tập'),
(1, 1, 'phía đông, hướng mặt trời mọc');

--  Dịch Tiếng Anh
INSERT INTO Translation (meaning_id, target_language_id, translate_text, translate_define) VALUES
(1, 2, 'winter', 'the coldest season of the year'),
(2, 2, 'crowded', 'full of people'),
(3, 2, 'east', 'the direction where the sun rises');

--  Dịch Tiếng Nhật
INSERT INTO Translation (meaning_id, target_language_id, translate_text, translate_define) VALUES
(1, 3, '冬', '一年で最も寒い季節'),  -- mùa lạnh nhất trong năm
(2, 3, '賑やか', '人がたくさん集まっている'), -- có nhiều người tụ tập
(3, 3, '東', '太陽が昇る方向'); -- hướng mặt trời mọc

-- Ví dụ  
INSERT INTO Example (meaning_id, example_text) VALUES
(1, 'Mùa đông ở Hà Nội rất lạnh'),
(2, 'Phố cổ Hà Nội đông đúc vào cuối tuần'),
(3, 'Mặt trời mọc ở hướng đông');
 
INSERT INTO ExampleTranslate (example_id, target_language_id, translated_example) VALUES
(1, 2, 'Winter in Hanoi is very cold'),
(1, 3, 'ハノイの冬はとても寒い'),
(2, 2, 'The Hanoi Old Quarter is crowded on weekends'),
(2, 3, '週末のハノイ旧市街はにぎやかです'),
(3, 2, 'The sun rises in the east'),
(3, 3, '太陽は東から昇ります');

-- Lấy tất cả các nghĩa của từ 'đông' và bản dịch 
SELECT 
	w.text as word,
	wt.type_name as word_type,
    m.define,
    l.language_name as target_language,
    t.translate_text,
    t.translate_define
FROM Word w 
JOIN Meaning m ON w.word_id = m.word_id
JOIN WordType wt ON m.type_id = wt.type_id
JOIN Translation t ON m.meaning_id = t.meaning_id
JOIN Language l ON t.target_language_id = l.language_id
WHERE w.text = 'đông';

-- Lấy ví dụ và bản dịch
SELECT 
    e.example_text AS vietnamese_example,
    l.language_name,
    et.translated_example
FROM Example e
JOIN ExampleTranslate et ON e.example_id = et.ex_translate_id
JOIN Language l ON et.target_language_id = l.language_id
JOIN Meaning m ON e.meaning_id = m.meaning_id
JOIN Word w ON m.word_id = w.word_id
WHERE w.text = 'đông';


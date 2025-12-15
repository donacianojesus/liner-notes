-- Create users table
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_public_share_date TIMESTAMP
);

-- Create albums table
CREATE TABLE albums (
    id BIGSERIAL PRIMARY KEY,
    spotify_id VARCHAR(100) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    artist VARCHAR(255) NOT NULL,
    artwork_url TEXT,
    release_date DATE,
    album_type VARCHAR(50),
    total_tracks INTEGER
);

-- Create journal_entries table
CREATE TABLE journal_entries (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    album_id BIGINT NOT NULL,
    listen_date DATE NOT NULL,
    mood VARCHAR(50),
    reflection TEXT,
    tags TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (album_id) REFERENCES albums(id) ON DELETE RESTRICT
);

-- Create public_posts table
CREATE TABLE public_posts (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    album_id BIGINT NOT NULL,
    listen_date DATE NOT NULL,
    mood VARCHAR(50),
    reflection TEXT NOT NULL,
    tags TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    save_count INTEGER DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (album_id) REFERENCES albums(id) ON DELETE RESTRICT
);

-- Create user_saved_posts join table (many-to-many)
CREATE TABLE user_saved_posts (
    user_id BIGINT NOT NULL,
    post_id BIGINT NOT NULL,
    saved_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES public_posts(id) ON DELETE CASCADE
);

-- Create indexes for performance
CREATE INDEX idx_journal_user_created ON journal_entries(user_id, created_at DESC);
CREATE INDEX idx_journal_album ON journal_entries(album_id);

CREATE INDEX idx_public_created ON public_posts(created_at DESC);
CREATE INDEX idx_public_user_created ON public_posts(user_id, created_at DESC);
CREATE INDEX idx_public_album ON public_posts(album_id);

CREATE INDEX idx_albums_spotify ON albums(spotify_id);

CREATE INDEX idx_saved_posts_user ON user_saved_posts(user_id);
CREATE INDEX idx_saved_posts_post ON user_saved_posts(post_id);

-- Add constraint to enforce one share per day per user
CREATE UNIQUE INDEX idx_one_share_per_day 
ON public_posts(user_id, DATE(created_at));

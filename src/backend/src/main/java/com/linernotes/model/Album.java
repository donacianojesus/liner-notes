package com.linernotes.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Table(name = "albums")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Album {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "spotify_id", unique = true, nullable = false, length = 100)
    private String spotifyId;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String artist;

    @Column(name = "artwork_url", columnDefinition = "TEXT")
    private String artworkUrl;

    @Column(name = "release_date")
    private LocalDate releaseDate;

    @Column(name = "album_type", length = 50)
    private String albumType; // album, single, compilation

    @Column(name = "total_tracks")
    private Integer totalTracks;

}

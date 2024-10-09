package com.ssafy.a303.backend.domain.report.repository;

import com.ssafy.a303.backend.domain.report.entity.DistinctIllegalParkingZone;
import com.ssafy.a303.backend.domain.report.entity.IllegalParkingZone;
import com.ssafy.a303.backend.domain.report.entity.Location;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IllegalParkingZoneRepository extends JpaRepository<IllegalParkingZone, Long> {

//    @Query("SELECT new com.ssafy.a303.backend.domain.report.entity.Location(i.location.longitude, i.location.latitude) FROM IllegalParkingZone i ")

    @Query("SELECT z FROM IllegalParkingZone z WHERE " +
            "(6371000 * ACOS(COS(RADIANS(:latitude)) * COS(RADIANS(z.location.latitude)) * " +
            "COS(RADIANS(z.location.longitude) - RADIANS(:longitude)) + " +
            "SIN(RADIANS(:latitude)) * SIN(RADIANS(z.location.latitude)))) <= 20")
    List<IllegalParkingZone> findWithin20Meters(@Param("longitude") double longitude, @Param("latitude") double latitude);


    @Query("SELECT z FROM IllegalParkingZone z WHERE " +
            "z.location.latitude BETWEEN :latitudeMin AND :latitudeMax AND " +
            "z.location.longitude BETWEEN :longitudeMin AND :longitudeMax")
    List<IllegalParkingZone> findWithin20Meters(
            @Param("longitudeMin") double longitudeMin,
            @Param("longitudeMax") double longitudeMax,
            @Param("latitudeMin") double latitudeMin,
            @Param("latitudeMax") double latitudeMax
    );

    @Query("SELECT z FROM DistinctIllegalParkingZone z WHERE " +
            "z.location.latitude BETWEEN :latitudeMin AND :latitudeMax AND " +
            "z.location.longitude BETWEEN :longitudeMin AND :longitudeMax")
    List<DistinctIllegalParkingZone> findWithin20MetersWithDistinctIndex(
            @Param("longitudeMin") double longitudeMin,
            @Param("longitudeMax") double longitudeMax,
            @Param("latitudeMin") double latitudeMin,
            @Param("latitudeMax") double latitudeMax
    );


}

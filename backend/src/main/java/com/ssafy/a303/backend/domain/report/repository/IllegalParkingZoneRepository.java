package com.ssafy.a303.backend.domain.report.repository;

import com.ssafy.a303.backend.domain.report.entity.IllegalParkingZone;
import com.ssafy.a303.backend.domain.report.entity.Location;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IllegalParkingZoneRepository extends JpaRepository<IllegalParkingZone, Long> {

    @Query("SELECT new com.ssafy.a303.backend.domain.report.entity.Location(i.location.longitude, i.location.latitude) FROM IllegalParkingZone i ")
    List<Location> findAllLocation();
}

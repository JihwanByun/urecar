package com.ssafy.a303.notification.repository;

import com.ssafy.a303.notification.entity.ResultNotification;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ResultNotificationRepository extends JpaRepository<ResultNotification, Long> {

    ResultNotification findById(long notificationId);

    List<ResultNotification> findByMemberIdAndIsDeletedFalseOrderByCreatedAtDesc(Long memberId);

}

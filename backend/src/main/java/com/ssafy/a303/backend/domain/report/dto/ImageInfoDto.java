package com.ssafy.a303.backend.domain.report.dto;

import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ImageInfoDto {

    private String fullPathName;
    private LocalDateTime createDateTime;

}

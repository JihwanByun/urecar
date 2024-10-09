package com.ssafy.a303.backend.domain.report.dto;

import java.util.List;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class GalleryResponseDto {

    List<byte[]> imageUrls;

}

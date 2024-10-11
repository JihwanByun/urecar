package com.ssafy.a303.backend.domain.report.handler;

import com.ssafy.a303.backend.domain.report.dto.ImageInfoDto;
import com.ssafy.a303.backend.exception.CustomException;
import com.ssafy.a303.backend.exception.ErrorCode;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.TimeZone;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class ImageHandler {

    public static String imageUrl;

    @Value("${image.url}")
    public void setKey(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public static ImageInfoDto save(Long memberId, MultipartFile image) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddkkmmss");
        sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));

        String fileName = sdf.format(new Date(Long.parseLong(String.valueOf(new Timestamp(System.currentTimeMillis()).getTime()))));
        File folder = new File(imageUrl + memberId);
        if (!folder.mkdir() && !folder.exists()  ) {
                throw new CustomException(ErrorCode.CANT_FOUND_FOLDER);
        }

        String fullPathName =  folder.getPath() + "/" + fileName + ".jpg";
        try {
            image.transferTo(new File(fullPathName));
            return ImageInfoDto.builder()
                    .fullPathName(fullPathName)
                    .createDateTime(LocalDateTime.parse(fileName, DateTimeFormatter.ofPattern("yyyyMMddkkmmss"))
            ).build();
        } catch (IOException e) {
            throw new CustomException(ErrorCode.IMAGE_SAVE_FAILED);
        }
    }

    public static byte[] urlToBytes(String url) throws CustomException {
        try {
            return IOUtils.toByteArray(new FileInputStream(url));
        } catch (IOException e) {
            throw new CustomException(ErrorCode.IMAGE_CHANGE_FAILED);
        }

    }

}
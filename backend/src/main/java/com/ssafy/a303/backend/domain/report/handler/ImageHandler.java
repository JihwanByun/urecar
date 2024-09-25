package com.ssafy.a303.backend.domain.report.handler;

import com.ssafy.a303.backend.exception.CustomException;
import com.ssafy.a303.backend.exception.ErrorCode;
import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.springframework.web.multipart.MultipartFile;

public class ImageHandler {

    public String save(Integer memberId, MultipartFile image) {
        String fileName = new SimpleDateFormat("yyyyMMddkkmmss")
                .format(new Date(Long.parseLong(String.valueOf(new Timestamp(System.currentTimeMillis()).getTime()))));
        File folder = new File("C:\\Users\\SSAFY\\Desktop\\imageFolder\\" + memberId);
        if (!folder.exists() && !folder.mkdir()) {
                throw new CustomException(ErrorCode.IMAGE_SAVE_FAILED);
        }

        String fullPathName =  folder.getPath() + "\\" + fileName + ".jpg";
        try {
            image.transferTo(new File(fullPathName));
            return fullPathName;
        } catch (IOException e) {
            throw new CustomException(ErrorCode.IMAGE_SAVE_FAILED);
        }
    }

}
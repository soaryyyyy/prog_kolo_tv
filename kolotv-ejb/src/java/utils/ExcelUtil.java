package utils;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.awt.*;
import java.util.Map;

public class ExcelUtil {
    public static Map<String,XSSFCellStyle> createStyleForHexColor(XSSFWorkbook workbook, String hexColor, Map<String, XSSFCellStyle> styleCache) {

        XSSFCellStyle style = styleCache.get(hexColor);
        if (style == null) {
            Color awtColor = Color.decode(hexColor);
            byte[] rgb = new byte[]{
                    (byte) awtColor.getRed(),
                    (byte) awtColor.getGreen(),
                    (byte) awtColor.getBlue()
            };

            XSSFColor poiColor = new XSSFColor(rgb);
            style = workbook.createCellStyle();
            style.setFillForegroundColor(poiColor);
            style.setFillPattern(FillPatternType.SOLID_FOREGROUND);

            styleCache.put(hexColor, style); // cache le style pour réutilisation
        }
        return styleCache;
    }

    public static XSSFCellStyle  getHeaderStyle(XSSFWorkbook workbook){
        XSSFCellStyle  headerStyle = workbook.createCellStyle();
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);

        headerStyle.setTopBorderColor(IndexedColors.BLACK.getIndex());
        headerStyle.setBottomBorderColor(IndexedColors.BLACK.getIndex());
        headerStyle.setLeftBorderColor(IndexedColors.BLACK.getIndex());
        headerStyle.setRightBorderColor(IndexedColors.BLACK.getIndex());
//
//        XSSFFont font = workbook.createFont();
//        font.setFontName("Arial");
//        font.setFontHeightInPoints((short) 12);
//        headerStyle.setFont(font);

        return headerStyle;
    }
}

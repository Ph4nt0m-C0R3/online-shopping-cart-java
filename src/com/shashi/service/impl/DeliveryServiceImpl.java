// DeliveryServiceImpl.java
package com.shashi.service.impl;

import com.shashi.beans.DeliveryResult;
import com.shashi.service.DeliveryService;

public class DeliveryServiceImpl implements DeliveryService {

    private void fill(DeliveryResult r, boolean ok, double fee, int days, String area) {
        r.setAvailable(ok);
        r.setFee(fee);
        r.setWaitingDays(days);
        r.setAreaName(area);
    }

    @Override
    public DeliveryResult checkDelivery(String postalCode) {
        DeliveryResult result = new DeliveryResult();
        if (postalCode == null || postalCode.trim().isEmpty()) {
            fill(result, false, 0, 0, null);
            return result;
        }
        switch (postalCode.trim()) {
            // Central Yangon – 2000 MMK, 1 day
            case "11182": fill(result, true, 2000, 1, "Kyauktada, Yangon"); break;
            case "11141": case "11142": case "11143": fill(result, true, 2000, 1, "Pabedan, Yangon"); break;
            case "11131": fill(result, true, 2000, 1, "Lanmadaw, Yangon"); break;
            case "11162": fill(result, true, 2000, 1, "Botahtaung, Yangon"); break;
            case "11171": fill(result, true, 2000, 1, "Pazundaung, Yangon"); break;

            // Inner Yangon – 3000 MMK, 2 days
            case "11111": fill(result, true, 3000, 2, "Sanchaung, Yangon"); break;
            case "11101": fill(result, true, 3000, 2, "Kyeemyindaing, Yangon"); break;
            case "11211": fill(result, true, 3000, 2, "Tamwe, Yangon"); break;
            case "11221": case "11222": fill(result, true, 3000, 2, "Mingalar Taung Nyunt, Yangon"); break;
            case "11191": fill(result, true, 3000, 2, "Dagon, Yangon"); break;
            case "11021": fill(result, true, 3000, 2, "Mingaladon, Yangon"); break;
            case "11011": case "11012": fill(result, true, 3000, 2, "Insein, Yangon"); break;
            case "11051": case "11052": fill(result, true, 3000, 2, "Hlaing/Hlaingthayar (inner), Yangon"); break;
            case "11041": fill(result, true, 3000, 2, "Kamayut, Yangon"); break;
            case "11061": case "11062": fill(result, true, 3000, 2, "Mayangone, Yangon"); break;
            case "11071": case "11072": fill(result, true, 3000, 2, "Thingangyun, Yangon"); break;
            case "11081": case "11082": fill(result, true, 3000, 2, "Yankin, Yangon"); break;
            case "11201": fill(result, true, 3000, 2, "Bahan, Yangon"); break;
            case "11241": fill(result, true, 3000, 2, "Dawbon, Yangon"); break;
            case "11231": fill(result, true, 3000, 2, "Tharkayta, Yangon"); break;

            // Outer Yangon – 4000 MMK, 3 days
            case "11401": fill(result, true, 4000, 3, "Hlaingtharyar, Yangon"); break;
            case "11411": fill(result, true, 4000, 3, "Shwe Pyi Thar, Yangon"); break;
            case "11031": case "11032": fill(result, true, 4000, 3, "North Okkalapa, Yangon"); break;
            case "11091": fill(result, true, 4000, 3, "South Okkalapa, Yangon"); break;
            case "11421": fill(result, true, 4000, 3, "Dagon Myothit (East), Yangon"); break;
            case "11431": fill(result, true, 4000, 3, "Dagon Myothit (South), Yangon"); break;
            case "11301": fill(result, true, 4000, 3, "Kyauktan, Yangon"); break;
            case "11291": fill(result, true, 4000, 3, "Thanlyin, Yangon"); break;

            default: fill(result, false, 0, 0, null);
        }
        return result;
    }
}
package com.shashi.service;

import com.shashi.beans.DeliveryResult;

public interface DeliveryService {
    DeliveryResult checkDelivery(String postalCode);
}
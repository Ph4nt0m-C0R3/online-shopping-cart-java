// DeliveryResult.java
package com.shashi.beans;

public class DeliveryResult {
    private boolean available;
    private double fee;
    private int waitingDays;
    private String areaName;

    public boolean isAvailable() { return available; }
    public void setAvailable(boolean available) { this.available = available; }

    public double getFee() { return fee; }
    public void setFee(double fee) { this.fee = fee; }

    public int getWaitingDays() { return waitingDays; }
    public void setWaitingDays(int waitingDays) { this.waitingDays = waitingDays; }

    public String getAreaName() { return areaName; }
    public void setAreaName(String areaName) { this.areaName = areaName; }
}
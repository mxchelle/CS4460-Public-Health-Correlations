import java.util.*;

/*
 * Creates the menu at the bottom of the page with saved screenshots
 */
public class MapMenu{
  Map map;
  private ArrayList<Snapshot> snapshots = new ArrayList<Snapshot>();
  Button saveButton;
  ArrayList<Button> deleteButtons = new ArrayList<Button>();
  int y, x;
  int numberOfSnapshots;
  int deletedSnapshots;
  ArrayList<Integer> availableSlots = new ArrayList<Integer>();
  
  public MapMenu(Map map, int x, int y){
    this.map = map;
    this.y =y;
    this.x =x;
    saveButton = new Button("Save This View", 650, y, 150, 40);
    cp5.addSlider("years")
       .setPosition(40, y)
       .setWidth(500)
       .setHeight(40)
       .setRange(1999,2012) // values can range from big to small as well
       .setValue(2012)
       .setNumberOfTickMarks(14)
       .setColorTickMark(0)
       .snapToTickMarks(true) 
       .setSliderMode(Slider.FLEXIBLE)
       .setTriggerEvent(Slider.PRESSED) 
       ;
   
   //initialize all snashots and the available slots list.
   for (int i = 0; i < 6; i = i+1){
     availableSlots.add(i);
     snapshots.add(new Snapshot(i));
   }

  }
  
  //draws the save button, all snapshots, and all deletebuttons.
  public void draw(){
    saveButton.draw();
    for (Snapshot aSnapshot : snapshots){
      aSnapshot.draw();
    }

    for (Button aDeleteButton : deleteButtons){
      aDeleteButton.draw();
    }
  }
  
  public void mousePressed(){
     int deleteIndex = 0;
     boolean deleted = false;
     PImage image;
     
     //adds the screenshot if the save button is pressed
     if (saveButton.pressed()) {
       if (map.getView() == null) {
         map.setView(0);
       }
       if (availableSlots.size() < 1) {
         javax.swing.JOptionPane.showMessageDialog(null, "You may only save 6 views, please delete one or more views.");
       } else {
       image = get(0,100,800,400);
       Collections.sort(availableSlots);
       int slot = availableSlots.get(0);
       snapshots.get(slot).setSnapshot(image, slot, (int)Math.round(cp5.getController("years").getValue()), map.getView()); 
       if (deleteButtons.size()<6){
         Button deleteButton = new Button("X",slot*200+190, heightH-130, 10,10, slot);
         deleteButtons.add(slot,deleteButton);
       } else {
         deleteButtons.get(slot).show();
       }
       availableSlots.remove(0);
       }
     }
     
     //loops through all delete buttons to check if any were pressed, and update the snapshots accordingly.
     for (Button aDeleteButton : deleteButtons){
       if (aDeleteButton.pressed()) {
         int snapshotIndex = aDeleteButton.getIndex();
         Snapshot deletedSnapshot = snapshots.get(snapshotIndex);
         deleteIndex = deletedSnapshot.getSlot();
         deletedSnapshot.delete();
         availableSlots.add(0,snapshotIndex);
         deleted = true;
       }
     }
     
     //hides the delete button if needed.
     if (deleted) {
       deleteButtons.get(deleteIndex).hide();
     }
     
     //updates the main screen with the clicked snapshot.
     for (Snapshot aSnapshot : snapshots) {
       if (aSnapshot.pressed()) {
         //update image       
         gradientCheck = aSnapshot.getGradientNumber();
         map.setView(aSnapshot.getGradientNumber());
         map.changeYear(aSnapshot.getYear()-1999);
         cp5.getController("years").setValue(aSnapshot.getYear());
       }
     }
  }
  
  public void drawYearSlider(){

  } 
}

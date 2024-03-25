import java.util.*;

ArrayList<Point> points = new ArrayList<>();
ArrayList<Edge> edges = new ArrayList<>();
ArrayList<Triangle> triangles = new ArrayList<>();
ArrayList<Edge> netEdges = new ArrayList<>();
int ps = 0;
float distance = 75;
ArrayList<Point> hullpts = new ArrayList<>();
float minx = 800;
Point hs = new Point(0, 0, -1);

ArrayList<Point> boundary = new ArrayList<>();
ArrayList<Point> eBoundary = new ArrayList<>();

boolean display = false;
boolean selectBoundary = true;
boolean done = false;

String url = "https://www.maptrove.com/media/catalog/product/900x600/s/t/stillwater-ok-map.jpg";
PImage image = loadImage(url);

void setup() {
  size(800, 600);
}

void draw() {
  strokeWeight(2);
  background(200);
  image(image, 0, 0);
  
  for(int i = 0; i < points.size(); i++) {
    stroke(0);
    fill(0);
    ellipse(points.get(i).x, points.get(i).y, 5, 5);
    if(!display) {
      fill(180, 50, 20, 80);
      noStroke();
      ellipse(points.get(i).x, points.get(i).y, 2 * distance, 2 * distance);
    }
  }
  for(int i = 0; i < edges.size(); i++) {
    Point x = edges.get(i).x;
    Point y = edges.get(i).y;
    if(display) {
      line(x.x, x.y, y.x, y.y);
    }
  }
  strokeWeight(2);
  noStroke();
  fill(180, 50, 20, 80);
  
  if(display){
  for(int i = 0; i < triangles.size(); i++) {
    Triangle t = triangles.get(i);
    triangle(t.x.x, t.x.y, t.y.x, t.y.y, t.z.x, t.z.y);
  }
  }
  
  if((!display && selectBoundary) || (display && !selectBoundary)) {
  for(int i = 0; i < boundary.size(); i++) {
    noStroke();
    fill(70, 180, 20);
    ellipse(boundary.get(i).x, boundary.get(i).y, 5, 5);
    fill(180, 50, 20, 80);
    //ellipse(hullpts.get(i).x, hullpts.get(i).y, 75, 75);
    stroke(50, 120, 20);
    if(i < boundary.size() - 1) {
      line(boundary.get(i).x, boundary.get(i).y, boundary.get(i+1).x, boundary.get(i+1).y);
    }
  }
  if(boundary.size() > 1) {
    line(boundary.get(boundary.size() - 1).x, boundary.get(boundary.size() - 1).y, boundary.get(0).x, boundary.get(0).y);
  }
  }
  else {
    for(int i = 0; i < eBoundary.size(); i++) {
    noStroke();
    fill(70, 180, 20);
    ellipse(eBoundary.get(i).x, eBoundary.get(i).y, 5, 5);
    fill(180, 50, 20, 80);
    //ellipse(hullpts.get(i).x, hullpts.get(i).y, 75, 75);
    stroke(50, 120, 20);
    if(i < eBoundary.size() - 1) {
      line(eBoundary.get(i).x, eBoundary.get(i).y, eBoundary.get(i+1).x, eBoundary.get(i+1).y);
    }
  else {
    line(eBoundary.get(eBoundary.size() - 1).x, eBoundary.get(eBoundary.size() - 1).y, eBoundary.get(0).x, eBoundary.get(0).y);
  }
  }
  }
    
}

void keyPressed() {
  if(keyPressed == true) {
    if(key == ' ') {
   display = !display; 
    }
    if(key == 'b' && selectBoundary) {
      println("Boundary Completed");
      selectBoundary = false;
      eBoundary = new ArrayList<>(boundary);
      for(int i = 0; i < boundary.size() - 1; i++) {
        Point a = boundary.get(i);
        Point b = boundary.get((i+1));
        float d = a.distTo(b);
        float drops = 0;
        if(d > 2 * distance) {
          drops = a.distTo(b) / (2 * distance);
        }
        drops += 1;
        eBoundary.add(a);
        for(int j = 1; j < (int)drops; j++) {
          float newX = (a.x * ((j * 2 * (distance-0.5))/d)) + (b.x * (1-((j * 2 * (distance-0.5))/d)));
          float newY = (a.y * ((j * 2 * (distance-0.5))/d)) + (b.y * (1-((j * 2 * (distance-0.5))/d)));
          Point nw = new Point(newX, newY, ps);
          nw.addThis();
          eBoundary.add(nw);
          ps++;
        }
        eBoundary.add(b);
      }
       Point a = boundary.get(boundary.size() - 1);
       Point b = boundary.get(0);
       float d = a.distTo(b);
        float drops = 0;
        if(d > 2 * distance) {
          drops = a.distTo(b) / (2 * distance);
        }
        drops += 1;
        eBoundary.add(a);
        for(int j = 1; j < (int)drops; j++) {
          float newX = (a.x * ((j * 2 * (distance-0.5))/d)) + (b.x * (1-((j * 2 * (distance-0.5))/d)));
          float newY = (a.y * ((j * 2 * (distance-0.5))/d)) + (b.y * (1-((j * 2 * (distance-0.5))/d)));
          Point nw = new Point(newX, newY, ps);
          nw.addThis();
          eBoundary.add(nw);
          ps++;
        }
        eBoundary.add(b);
        
       for(int i = 0; i < eBoundary.size(); i++) {
         Edge e = new Edge(eBoundary.get(i), eBoundary.get((i+1) % (eBoundary.size())));
          for(int j = 0; j < edges.size(); j++) {
            if(e.equals(edges.get(j))) {
              edges.get(j).isBoundary = true;
            }
          }
      }
      
    }
    if(key == ENTER) {
      done = true;
      int[][] B = new int[edges.size()][triangles.size()];
    int[] g = new int[edges.size()];
    
    int ind = 0;
    for(int r = 0; r < g.length; r++) {
      if(edges.get(r).isBoundary) {
        ind++;
        g[r] = 1;
      }
    }
    println();
    println();
    
    g[ind - 1] = -1;
        for(int t = 0; t < triangles.size(); t++) {
          for(int e = 0; e < edges.size(); e++) {
            if(triangles.get(t).x.ID == edges.get(e).x.ID && triangles.get(t).y.ID == edges.get(e).y.ID) {
              B[e][t] = 1;
            }
            else if(triangles.get(t).y.ID == edges.get(e).x.ID && triangles.get(t).z.ID == edges.get(e).y.ID) {
              B[e][t] = 1;
            }
            
            else if(triangles.get(t).x.ID == edges.get(e).x.ID && triangles.get(t).z.ID == edges.get(e).y.ID) {
              B[e][t] = -1;
            }
          }
    }
    
    println();
    println("Boundary Vector: ");
    println("-------------------");
    println();
    for(int r = 0; r < g.length; r++) {
      println(g[r]);
    }
    
    
    println();
    println();
    println("Boundary Matrix: ");
    println("-------------------");
    println();
    for(int r = 0; r < B.length; r++) {
      for(int c = 0; c < B[0].length; c++) {
        print(B[r][c] + " ");
      }
      println();
    }

    }
  }
}

void mousePressed() {
  Point p = new Point(mouseX, mouseY, ps);
  p.addThis();
  ps++;
  done = false;
  
  if(p.x <= minx) {
    minx = p.x;
    hs = p;
  }
  
  //updateHull();
  
  
}

void updateHull() {
  hullpts.clear();
  for(int i = 0; i < edges.size(); i++) {
    //edges.get(i).isHull = false;
  }
  for(int i = 0; i < points.size(); i++) {
    points.get(i).intan(hs);
  }
  netEdges = new ArrayList<Edge>(edges);
  
  Collections.sort(points);
  
  hullpts.add(hs);
  if(ps >= 2) {
    hullpts.add(points.get(0));
    for(int i = 1; i < points.size(); i++) {
      float vec1_x = hullpts.get(hullpts.size() - 1).x - hullpts.get(hullpts.size() - 2).x;
      float vec1_y = hullpts.get(hullpts.size() - 1).y - hullpts.get(hullpts.size() - 2).y;
  
      float vec2_x = -(hullpts.get(hullpts.size() - 1).x - points.get(i).x);
      float vec2_y = -(hullpts.get(hullpts.size() - 1).y - points.get(i).y);
      
      float det = (vec1_x * vec2_y) - (vec1_y * vec2_x);
      
      while(det < 0 && hullpts.size() > 1) {
        hullpts.remove(hullpts.size() - 1);
    
        if (hullpts.size() >= 2) {
          vec1_x = hullpts.get(hullpts.size() - 2).x - hullpts.get(hullpts.size() - 1).x;
          vec1_y = hullpts.get(hullpts.size() - 2).y - hullpts.get(hullpts.size() - 1).y;
          vec2_x = hullpts.get(hullpts.size() - 1).x - points.get(i).x;
          vec2_y = hullpts.get(hullpts.size() - 1).y - points.get(i).y;
          det = (vec1_x * vec2_y) - (vec1_y * vec2_x);
        }
    }
    hullpts.add(points.get(i));
    }
  }
  for(int i = 0; i < hullpts.size(); i++) {
      if(hullpts.size() > 1) {
      Edge e = new Edge(hullpts.get(i), hullpts.get((i+1) % (hullpts.size())));
      boolean found = false;
      for(int j = 0; j < edges.size(); j++) {
        if(e.equals(edges.get(j))) {
          //edges.get(j).isHull = true;
          found = true;
        }
      }
      if(!found) {
        //e.isHull = true;
        netEdges.add(e);
        //println(hullpts.get(i).ID + " " + hullpts.get((i+1)% (hullpts.size())).ID);
      }
    }
  }
  
}


class Point implements Comparable<Point> {
  float x, y, angle;
  int ID;
  ArrayList<Point> connections = new ArrayList<>();
  
  Point(float x, float y, int i) {
    this.x = x;
    this.y = y;
    ID = i;
  }
  
  float distTo(Point p) {
    return (float)Math.sqrt(((x - p.x) * (x - p.x)) + ((y - p.y) * (y - p.y)));
  }
  
  void intan(Point p2) {
        float xDiff = p2.x - this.x;
        if(xDiff == 0) angle = -1000;
        else angle = atan((p2.y - this.y)/(p2.x - this.x));
    }
    
    int compareTo(Point o) {
        if (o.angle > angle)  return -1;
        if (o.angle == angle) return 0;
        return 1;
    }
    
    void addThis() {
      for(int i = 0; i < points.size(); i++) {
    if(this.distTo(points.get(i)) <= 2 * distance) {
      this.connections.add(points.get(i));
      points.get(i).connections.add(this);
      edges.add(new Edge(this, points.get(i)));
    }
  }
  points.add(this);
  if(selectBoundary) {
    boundary.add(this);
  }
  
  for(Point p2 : this.connections) {
    for(Point p3: p2.connections) {
      if(p3.ID != this.ID) {
        if(p3.connections.contains(this)) {
          triangles.add(new Triangle(this, p2, p3));
        }
      }
    }
  }
    }
  
}

class Edge {
  Point x, y;
  boolean isBoundary;
  
  Edge(Point x, Point y) {
    if(x.ID < y.ID) {
      this.x = x;
      this.y = y;
    }
    else {
      this.x = y;
      this.y = x;
    }
    isBoundary = false;
  }
  
  boolean equals(Object o) {
   Edge other = (Edge)o;
   if(x.ID == other.x.ID && y.ID == other.y.ID) {
     return true;
   }
   return false;
  }
}

class Triangle {
  Point x, y, z;
  
  Triangle(Point x, Point y, Point z) {
    if(x.ID < y.ID && y.ID < z.ID) {
      this.x = x;
      this.y = y;
      this.z = z;
    }
    else if(x.ID < z.ID && z.ID < y.ID) {
      this.x = x;
      this.y = z;
      this.z = y;
    }
    else if(y.ID < x.ID && x.ID < z.ID) {
      this.x = y;
      this.y = x;
      this.z = z;
    }
    else if(y.ID < z.ID && z.ID < x.ID) {
      this.x = y;
      this.y = z;
      this.z = x;
    }
    else if(z.ID < x.ID && x.ID < y.ID) {
      this.x = z;
      this.y = x;
      this.z = y;
    }
    else {
      this.x = z;
      this.y = y;
      this.z = x;
    }
  }
}  

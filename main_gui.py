from PyQt5.QtWidgets import QApplication, QWidget, QMainWindow, QLabel, QLineEdit, QVBoxLayout, QPushButton, QMessageBox
from PyQt5.QtCore import QSize, Qt
import run_script as rs
import sys


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.run_button = None
        self.env_input = None
        self.main_input = None
        self.dir_input = None
        self.env_label = None
        self.main_label = None
        self.dir_label = None
        self.setWindowTitle("DeuteRater Turbo Executable")
        self.setFixedSize(QSize(600, 300))
        
    def initUI(self):
        self.dir_label = QLabel(self)
        self.dir_label.setText("Full path of DeuteRater directory: ")
        self.main_label = QLabel(self)
        self.main_label.setText("File name for the main script: ")
        self.env_label = QLabel(self)
        self.env_label.setText("Name of the Anaconda environment used by DeuteRater: ")
        
        self.dir_input = QLineEdit(self)
        self.main_input = QLineEdit(self)
        self.env_input = QLineEdit(self)
        
        self.run_button = QPushButton(self)
        self.run_button.setText("Run")
        
        layout = QVBoxLayout(self)
        layout.addWidget(self.dir_label)
        layout.addWidget(self.dir_input)
        layout.addWidget(self.main_label)
        layout.addWidget(self.main_input)
        layout.addWidget(self.env_label)
        layout.addWidget(self.env_input)
        layout.addWidget(self.run_button)
        
        container = QWidget(self)
        container.setLayout(layout)
        self.setCentralWidget(container)
        
        # when run button is clicked, call the appropriate function
        self.run_button.clicked.connect(self.onButtonClicked)
        
    # takes text from user and passes it along after run button is pressed
    def onButtonClicked(self):
        check_result = rs.storeInfo(self.dir_input.text(), self.main_input.text(), self.env_input.text())
        
        # display error message if we didn't get all the data we need.
        if check_result == "missing_data":
            msg = QMessageBox(self)
            msg.setWindowTitle("ERROR")
            msg.setText("Missing needed info. Please fill out each input box (directory, main file, and Anaconda environment).")
            x = msg.exec_()
        if check_result == "failed":
            msg = QMessageBox(self)
            msg.setWindowTitle("ERROR")
            msg.setText("Script failed. Please make sure paths and file names provided are correct. Check the ReadMe for more details and troubleshooting.")
    

def main():
    # initialize app and window instances
    app = QApplication(sys.argv)
    window = MainWindow()
    window.initUI()
    window.show()

    # start event loop
    app.exec()
    
    
if __name__ == "__main__":
    main()
    